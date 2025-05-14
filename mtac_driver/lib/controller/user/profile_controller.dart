import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/user/user_service.dart';

class ProfileController extends GetxController {
  //
  final Rxn<UserModel> infoUser = Rxn<UserModel>();
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
  Future<void> updateUser(Map<String, dynamic> updateUser) async {
    try {
       await UserService().updateUser(updateUser);
    
      Get.snackbar('Thành công', 'Thông tin của bạn đã được cập nhật.',
          snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.green);
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
}
