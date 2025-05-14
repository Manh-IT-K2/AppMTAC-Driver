import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/user/login_service.dart';
import 'package:mtac_driver/service/user/user_service.dart';
import 'package:mtac_driver/theme/color.dart';

class ProfileController extends GetxController {
  //
  final Rxn<UserModel> infoUser = Rxn<UserModel>();
  final Rx<File?> imagePath = Rx<File?>(null);
  final log = Get.find<LoginController>();
  final sche = Get.find<ScheduleController>();
  // init
  @override
  void onInit() {
    super.onInit();
    getInforUser();
  }

  // Call function get user from service
  Future<void> getInforUser() async {
    try {
      final user = await UserService().getUser();
      infoUser.value = user;
      if (kDebugMode) {
        print(user);
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.snackbar(
            'Lỗi', 'Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
        Get.offAllNamed(AppRoutes.login);
      }
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    }
  }

  // Call function update user from service
  Future<void> updateUser(
      Map<String, dynamic> updateUser) async {
    try {
     await UserService().updateUser(updateUser);
     log.getUserModel();
     sche.getUsername();
      Get.snackbar('Thành công', 'Thông tin của bạn đã được cập nhật.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.snackbar(
            'Lỗi', 'Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
        Get.offAllNamed(AppRoutes.login);
      }
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    }
  }

  // function chose image
  Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      imagePath.value = file;
      return file;
    } else {
      return null;
    }
  }
}
