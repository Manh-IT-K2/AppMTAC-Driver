import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import 'dart:async';

class DocumentInfo {
  String? documentNumber;
  String? documentType;

  @override
  String toString() => 'Document Type: $documentType\nDocument Number: $documentNumber';
}

class UpdateIdDocument extends StatefulWidget {
  const UpdateIdDocument({super.key});

  @override
  State<UpdateIdDocument> createState() => _UpdateIdDocumentState();
}

class _UpdateIdDocumentState extends State<UpdateIdDocument> {
  static const _captureInterval = Duration(milliseconds: 2000);
  static const _documentNumberPattern = r'\b\d{12}\b';
  
  static const _gplxKeywords = [
    'giấy phép lái xe',
    'bộ gtvt',
    'driver license'
  ];
  
  static const _cccdKeywords = [
    'căn cước công dân',
    'citizen identify card'
  ];

  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _profileController = Get.find<ProfileController>();

  CameraController? _cameraController;
  Timer? _captureTimer;
  String? documentType;
  String? documentNumber;
  
  bool _isCameraInitialized = false;
  bool _isDocumentDetected = false;
  bool _isProcessing = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    documentType = Get.arguments as String;
    _initCamera();
  }

  @override
  void dispose() {
    _captureTimer?.cancel();
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
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
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Camera initialization timed out');
        },
      );

      if (!mounted) return;

      await Future.wait([
        _cameraController!.setFlashMode(FlashMode.off),
        _cameraController!.setExposureMode(ExposureMode.auto),
        _cameraController!.setFocusMode(FocusMode.auto),
      ]);

      setState(() {
        _isCameraInitialized = true;
      });

      _startDocumentDetection();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  void _startDocumentDetection() {
    _captureTimer = Timer.periodic(_captureInterval, (timer) {
      if (!_isProcessing && mounted && _cameraController != null) {
        _processImage();
      }
    });
  }

  bool _containsAnyKeyword(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
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
      
      bool isDocumentDetected = false;
      String? tempDocNumber;
      final lines = recognizedText.text.split('\n');

      for (final line in lines) {
        final lowercaseLine = line.toLowerCase();
        
        // Check document type
        if (documentType == 'gplx' && _containsAnyKeyword(lowercaseLine, _gplxKeywords) ||
            documentType == 'cccd' && _containsAnyKeyword(lowercaseLine, _cccdKeywords)) {
          isDocumentDetected = true;
        }

        // Extract document number
        final match = RegExp(_documentNumberPattern).firstMatch(line);
        if (match != null) {
          tempDocNumber = match.group(0);
        }
      }

      // Document is only detected if both type and number are valid
      isDocumentDetected = isDocumentDetected && tempDocNumber != null;

      if (mounted) {
        setState(() {
          _isDocumentDetected = isDocumentDetected;
          documentNumber = tempDocNumber;
        });
      }

      await file.delete();
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      if (mounted) {
        _isProcessing = false;
      }
    }
  }

  Future<void> _takePicture() async {
    if (_isTakingPicture || 
        !_cameraController!.value.isInitialized || 
        !_isDocumentDetected || 
        documentNumber == null) return;

    _isTakingPicture = true;
    _captureTimer?.cancel();

    try {
      if (documentType == 'gplx') {
        final image = await _cameraController!.takePicture();
        if (mounted) {
          _profileController.imgPath.value = image.path;
          Get.back(result: documentNumber);
        }
      } else {
        Get.back(result: documentNumber);
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể chụp ảnh. Vui lòng thử lại'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      _isTakingPicture = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = documentType == 'gplx' ? "Cập nhật GPLX" : "Cập nhật CCCD";
    
    if (!_isCameraInitialized) {
      return Scaffold(
        appBar: AppBarCommon(hasMenu: false, title: title),
        body: Center(
          child: Image.asset(
            "assets/image/loadingDot.gif",
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarCommon(hasMenu: false, title: title),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          _buildOverlay(),
          _buildInstructions(),
          _buildCaptureButton(),
          if (!_isDocumentDetected) _buildGuidanceText(),
        ],
      ),
    );
  }

  Widget _buildGuidanceText() {
    return Positioned(
      bottom: 30.h,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          documentType == 'gplx' 
              ? "Di chuyển GPLX vào trong khung"
              : "Di chuyển CCCD vào trong khung",
          textAlign: TextAlign.center,
          style: PrimaryFont.bodyTextBold()
              .copyWith(color: Colors.white, fontSize: 16),
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
              color: _isDocumentDetected ? Colors.green : Colors.redAccent,
              width: 2
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    final String documentName = documentType == 'gplx' ? "GPLX" : "CCCD";
    return Positioned(
      top: 2.w,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Chụp ảnh $documentName hợp lệ của bạn",
              style: PrimaryFont.titleTextBold().copyWith(color: Colors.white),
            ),
            Text(
              "Đảm bảo $documentName của bạn rõ ràng và không bị lóa để xác minh thành công. Đặt $documentName vào trong khung và giữ cố định.",
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
        onTap: _isDocumentDetected ? _takePicture : null,
        child: Container(
          width: 100.w,
          height: 12.w,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _isDocumentDetected ? kPrimaryColor : Colors.grey,
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
