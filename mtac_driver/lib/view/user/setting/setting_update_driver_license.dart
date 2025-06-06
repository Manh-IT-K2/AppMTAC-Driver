import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

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

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;
    final image = await _cameraController!.takePicture();
    //final fileName = image.path.split('/').last;
    Get.back(result: image.path);
    //print("Đã chụp ảnh: ${fileName}");
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
            border: Border.all(color: Colors.redAccent, width: 2),
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
              "Đảm bảo ID của bạn rõ ràng và không bị lóa để xác minh thành công. Đặt ID vào trong khung và giữ cố định.",
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
        onTap: _takePicture,
        child: Container(
          width: 100.w,
          height: 12.w,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kPrimaryColor,
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
