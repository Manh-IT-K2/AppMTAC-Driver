import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/user/login_service.dart';

class LoginController extends GetxController {
  // inital variable
  final formKeyLogin = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  // password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // clear input email
  void clearInputPhone(){
    usernameController.text = "";
  }

  // Call login from loginService
  Future<void> login() async {
    if(!formKeyLogin.currentState!.validate()) return;

    isLoading.value = true;

    final success = await LoginService().login(
      username: usernameController.text,
      password: passwordController.text,
    );

    isLoading.value = false;

    if (success) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.snackbar("Lỗi", "Đăng nhập thất bại. Kiểm tra lại thông tin.",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.red);
    }
  }

  // // Call logout from loginService
  // Future<void> logOut() async {
  //   final success = await LoginService().logout();
  //   if (success) {
  //     Get.snackbar(
  //       "OK",
  //       "Đăng xuất thành công!.",
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: kPrimaryColor.withOpacity(0.1),
  //       colorText: Colors.green,
  //     );
  //     Get.offAllNamed(AppRoutes.login);
  //   } else {
  //     Get.snackbar(
  //       "Lỗi",
  //       "Đăng xuất thất bại!.",
  //       snackPosition: SnackPosition.TOP,
  //       colorText: Colors.red,
  //     );
  //   }
  // }

  // // Call checkLoginStatus from loginService
  // Future<void> checkLoginStatus() async {
  //   final success = await LoginService().checkLoginStatus();
  //   if (success) {
  //     Get.offAllNamed('/main');
  //   } else {
  //     Get.offAllNamed('/login');
  //   }
  // }

  // dispose
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
