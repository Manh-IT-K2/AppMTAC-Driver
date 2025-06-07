import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class LicenseInfo {
  String? licenseNumber;
  String? fullName;
  String? dateOfBirth;
  String? nationality;
  String? class_;
  String? validUntil;
  String? issuedBy;
  String? address;

  @override
  String toString() {
    return '''
Thông tin GPLX:
- Số GPLX: $licenseNumber
- Họ và tên: $fullName
- Ngày sinh: $dateOfBirth
- Quốc tịch: $nationality
- Hạng: $class_
- Có giá trị đến: $validUntil
- Nơi cấp: $issuedBy
- Nơi cư trú: $address
''';
  }
}

class SettingUpdateDriverLicense extends StatefulWidget {
  const SettingUpdateDriverLicense({super.key});

  @override
  State<SettingUpdateDriverLicense> createState() =>
      _SettingUpdateDriverLicenseState();
}

class _SettingUpdateDriverLicenseState
    extends State<SettingUpdateDriverLicense> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isLicenseDetected = false;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _isProcessing = false;
  Timer? _captureTimer;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
    }

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.max, // Lower resolution for better performance
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420 // Use YUV420 for better compatibility
            : ImageFormatGroup.bgra8888,
      );

      // Initialize with timeout
      await _cameraController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Camera initialization timed out');
        },
      );

      if (!mounted) return;

      // Configure camera
      await Future.wait([
        _cameraController!.setFlashMode(FlashMode.off),
        _cameraController!.setExposureMode(ExposureMode.auto),
        _cameraController!.setFocusMode(FocusMode.auto),
      ]);

      setState(() {
        _isCameraInitialized = true;
      });

      // Start periodic capture with longer interval
      _captureTimer =
          Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
        if (!_isProcessing && mounted && _cameraController != null) {
          try {
            await _processImage();
          } catch (e) {
            debugPrint('Error in periodic capture: $e');
          }
        }
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _processImage() async {
    if (_isProcessing || !_isCameraInitialized || !mounted) return;
    _isProcessing = true;

    try {
      final xFile = await _cameraController!.takePicture();
      final file = File(xFile.path);
      
      if (!await file.exists()) {
        debugPrint('Captured image file does not exist');
        return;
      }

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      // More comprehensive text detection
      final text = recognizedText.text.toLowerCase();
      bool isLicenseDetected = false;

      // Extract license information
      final licenseInfo = LicenseInfo();
      final lines = recognizedText.text.split('\n');
      
      for (var line in lines) {
        final lowercaseLine = line.toLowerCase();
        
        // Detect if this is a driver's license
        if ((lowercaseLine.contains('giấy phép lái xe') || lowercaseLine.contains('gplx')) &&
            (lowercaseLine.contains('việt nam') || lowercaseLine.contains('vietnam'))) {
          isLicenseDetected = true;
        } else if (lowercaseLine.contains('bộ gt') &&
            (lowercaseLine.contains('cộng hòa') || lowercaseLine.contains('việt nam'))) {
          isLicenseDetected = true;
        } else if (lowercaseLine.contains('driver') && lowercaseLine.contains('license')) {
          isLicenseDetected = true;
        }

        // Extract information
        if (lowercaseLine.contains('số') || lowercaseLine.contains('no')) {
          // Look for patterns like "Số: 123456" or "No.: 123456"
          final match = RegExp(r'(?:số:|no\.?:?)\s*(\d+)').firstMatch(lowercaseLine);
          if (match != null) {
            licenseInfo.licenseNumber = match.group(1);
          }
        }
        
        if (lowercaseLine.contains('họ tên') || lowercaseLine.contains('họ và tên') || lowercaseLine.contains('name')) {
          // Extract name after "Họ tên:" or similar patterns
          final match = RegExp(r'(?:họ tên:|họ và tên:|name:?)\s*(.+)').firstMatch(line);
          if (match != null) {
            licenseInfo.fullName = match.group(1)?.trim();
          }
        }

        if (lowercaseLine.contains('ngày sinh') || lowercaseLine.contains('sinh ngày') || lowercaseLine.contains('date of birth')) {
          // Look for date patterns
          final match = RegExp(r'(\d{2}[/-]\d{2}[/-]\d{4})').firstMatch(line);
          if (match != null) {
            licenseInfo.dateOfBirth = match.group(1);
          }
        }

        if (lowercaseLine.contains('quốc tịch') || lowercaseLine.contains('nationality')) {
          final match = RegExp(r'(?:quốc tịch:|nationality:?)\s*(.+)').firstMatch(line);
          if (match != null) {
            licenseInfo.nationality = match.group(1)?.trim();
          }
        }

        if (lowercaseLine.contains('hạng') || lowercaseLine.contains('class')) {
          final match = RegExp(r'(?:hạng:|class:?)\s*([A-F\d]+)').firstMatch(line);
          if (match != null) {
            licenseInfo.class_ = match.group(1);
          }
        }

        if (lowercaseLine.contains('giá trị đến') || lowercaseLine.contains('valid until')) {
          final match = RegExp(r'(\d{2}[/-]\d{2}[/-]\d{4})').firstMatch(line);
          if (match != null) {
            licenseInfo.validUntil = match.group(1);
          }
        }

        if (lowercaseLine.contains('nơi cấp') || lowercaseLine.contains('issued by')) {
          final match = RegExp(r'(?:nơi cấp:|issued by:?)\s*(.+)').firstMatch(line);
          if (match != null) {
            licenseInfo.issuedBy = match.group(1)?.trim();
          }
        }

        if (lowercaseLine.contains('nơi cư trú') || lowercaseLine.contains('address')) {
          final match = RegExp(r'(?:nơi cư trú:|address:?)\s*(.+)').firstMatch(line);
          if (match != null) {
            licenseInfo.address = match.group(1)?.trim();
          }
        }
      }

      // Additional checks for common fields
      if (!isLicenseDetected) {
        final hasCommonFields = text.contains('họ tên') ||
            text.contains('ngày sinh') ||
            text.contains('quốc tịch') ||
            text.contains('nationality') ||
            text.contains('date of birth');
        if (hasCommonFields) {
          isLicenseDetected = true;
        }
      }

      if (mounted) {
        setState(() {
          _isLicenseDetected = isLicenseDetected;
        });
        
        if (isLicenseDetected) {
          debugPrint('\n${licenseInfo.toString()}');
        }
      }

      // Clean up
      try {
        await file.delete();
      } catch (e) {
        debugPrint('Error deleting temporary file: $e');
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      if (mounted) {
        _isProcessing = false;
      }
    }
  }

  Future<void> _takePicture() async {
    // Prevent multiple taps
    if (_isTakingPicture ||
        !_cameraController!.value.isInitialized ||
        !_isLicenseDetected) return;

    _isTakingPicture = true;
    _captureTimer?.cancel(); // Stop the detection timer

    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.request();
        final photosStatus = await Permission.photos.request();
        
        if (!storageStatus.isGranted && !photosStatus.isGranted) {
          throw Exception('Storage/Photos permission not granted');
        }
      }

      final image = await _cameraController!.takePicture();
      
      // Save image to Pictures directory
      final directory = Platform.isAndroid 
          ? Directory('/storage/emulated/0/Pictures/MTAC') 
          : await getApplicationDocumentsDirectory();
          
      // Create directory if it doesn't exist
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'GPLX_$timestamp.jpg';
      final savedImage = File(path.join(directory.path, fileName));
      
      // Copy image to new location
      await File(image.path).copy(savedImage.path);
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã lưu ảnh vào ${savedImage.path}'),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Return the saved image path
        Get.back(result: savedImage.path);
      }
    } catch (e) {
      debugPrint('Error taking/saving picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể lưu ảnh. Vui lòng kiểm tra quyền truy cập'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      _isTakingPicture = false;
    }
  }

  @override
  void dispose() {
    _captureTimer?.cancel();
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(hasMenu: false, title: "Cập nhật GPLX"),
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),
                _buildOverlay(),
                _buildInstructions(),
                _buildCaptureButton(),
                if (!_isLicenseDetected)
                  Positioned(
                    bottom: 30.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Di chuyển GPLX vào trong khung",
                        textAlign: TextAlign.center,
                        style: PrimaryFont.bodyTextBold()
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: Image.asset(
                "assets/image/loadingDot.gif",
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _buildOverlay() {
    return Center(
      child: Container(
        width: 100.w,
        height: 50.h,
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 25.h),
          decoration: BoxDecoration(
            border: Border.all(
                color: _isLicenseDetected ? Colors.green : Colors.redAccent,
                width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Positioned(
      top: 2.w,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Chụp ảnh GPLX hợp lệ của bạn",
              style: PrimaryFont.titleTextBold().copyWith(color: Colors.white),
            ),
            Text(
              "Đảm bảo GPLX của bạn rõ ràng và không bị lóa để xác minh thành công. Đặt GPLX vào trong khung và giữ cố định.",
              textAlign: TextAlign.center,
              style: PrimaryFont.bodyTextMedium().copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Positioned(
      bottom: 20.h,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: _isLicenseDetected ? _takePicture : null,
        child: Container(
          width: 100.w,
          height: 12.w,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isLicenseDetected ? kPrimaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(15.w),
          ),
          child: Text(
            "Chụp ảnh",
            style: PrimaryFont.bodyTextBold().copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
