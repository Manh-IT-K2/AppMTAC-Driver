import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtac_driver/common/notify/show_notify_snackbar.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/user/user_service.dart';
import 'package:mtac_driver/shared/token_shared.dart';

class ProfileController extends GetxController {
  //
  final formKeyChangePass = GlobalKey<FormState>();
  //
  final Rxn<UserModel> infoUser = Rxn<UserModel>();
  final Rx<File?> imagePath = Rx<File?>(null);
  final loginController = Get.find<LoginController>();
  final scheduleController = Get.find<ScheduleController>();

  // inital variable manager password
  final passwordNewController = TextEditingController();
  final passwordNewConfirmController = TextEditingController();
  // final passwordController = TextEditingController();
  // final obscurePassword = true.obs;
  final obscurePasswordNew = true.obs;
  final obscurePasswordNewConfirm = true.obs;

  // init
  @override
  void onInit() {
    super.onInit();
    getInforUser();
  }

// password visibility
  // void togglePasswordVisibility() {
  //   obscurePassword.value = !obscurePassword.value;
  // }

  // password new visibility
  void togglePasswordNewVisibility() {
    obscurePasswordNew.value = !obscurePasswordNew.value;
  }

  // password new confirm visibility
  void togglePasswordNewConfirmVisibility() {
    obscurePasswordNewConfirm.value = !obscurePasswordNewConfirm.value;
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
        Get.offAllNamed(AppRoutes.main);
      }
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    }
  }

  // Call function update pass word from service
  Future<void> updatePassword(Map<String, dynamic> updateUser) async {
    try {
      if (!formKeyChangePass.currentState!.validate()) return;

      await UserService().updateUser(updateUser);
      showSuccess('Đổi mật khẩu thành công.');
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      if (e.toString().contains('401')) {
        showError('Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.');
        Get.offAllNamed(AppRoutes.login);
        removeToken();
      }
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    }
  }

  // Call function update user from service
  Future<void> updateUser(Map<String, dynamic> updateUser) async {
    try {
      await UserService().updateUser(updateUser);
      loginController.loadUserModel();
      scheduleController.loadUsername();
      showSuccess('Thông tin của bạn đã được cập nhật.');
    } catch (e) {
      if (e.toString().contains('401')) {
        showError('Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.');
        Get.offAllNamed(AppRoutes.login);
        removeToken();
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
