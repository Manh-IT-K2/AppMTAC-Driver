import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/common/notify/show_notify_snackbar.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/user/login_service.dart';

class LoginController extends GetxController {
  // inital variable
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final isFogotPass = false.obs;

  // initial varialbe search help & FQAs
  List<String> helpTitles = ['Tất cả', 'Tổng quan', 'Dịch vụ', 'Tài khoản'];
  final searchHelpFqas = TextEditingController();
  final isSelectedHelp = 0.obs;

  // initial variable contact us
  final arrowDownService = false.obs;
  final arrowDownWhatsApp = false.obs;
  final arrowDownWebsite = false.obs;
  final arrowDownTwitter = false.obs;
  final arrowDownFacebook = false.obs;
  final arrowDownInstagram = false.obs;

  // toggle is forgot pass visibility
  void toggleIsFogotPassVisibility() {
    isFogotPass.value = !isFogotPass.value;
  }

  // arrow down service visibility
  void toggleArrowDownServiceVisibility() {
    arrowDownService.value = !arrowDownService.value;
  }

  // arrow down website visibility
  void toggleArrowDownWebsiteVisibility() {
    arrowDownWebsite.value = !arrowDownWebsite.value;
  }

  // arrow down whatsApp visibility
  void toggleArrowDownWhatsAppVisibility() {
    arrowDownWhatsApp.value = !arrowDownWhatsApp.value;
  }

  // arrow down twitter visibility
  void toggleArrowDownTwitterVisibility() {
    arrowDownTwitter.value = !arrowDownTwitter.value;
  }

  // arrow down facebook visibility
  void toggleArrowDownFacebookVisibility() {
    arrowDownFacebook.value = !arrowDownFacebook.value;
  }

  // arrow down instagram visibility
  void toggleArrowDownInstagramVisibility() {
    arrowDownInstagram.value = !arrowDownInstagram.value;
  }

  // password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // clear input email
  void clearInputPhone() {
    usernameController.text = "";
  }

  // Call login from loginService
  Future<void> login() async {
    isLoading.value = true;

    final success = await LoginService().login(
      username: usernameController.text,
      password: passwordController.text,
    );

    isLoading.value = false;

    if (success) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      showError("Đăng nhập thất bại. Kiểm tra lại thông tin.");
    }
  }

  // Call logout from loginService
  Future<void> logOut() async {
    final success = await LoginService().logout();
    if (success) {
      showSuccess("Đăng xuất thành công!.");
      Get.offAllNamed(AppRoutes.login);
    } else {
      showError("Đăng xuất thất bại!.");
    }
  }

  // Call checkLoginStatus from loginService
  Future<void> checkLoginStatus() async {
    final success = await LoginService().checkLoginStatus();
    if (success) {
      Get.offAllNamed('/main');
    } else {
      Get.offAllNamed('/login');
    }
  }

  // dispose
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
