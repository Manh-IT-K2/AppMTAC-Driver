import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/user/login_service.dart';
import 'package:mtac_driver/shared/user/user_shared.dart';
import 'package:mtac_driver/theme/color.dart';

class LoginController extends GetxController {
  // inital variable
  final formKeyLogin = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  // initial varialbe search help & FQAs
  List<String> helpTitles = ['Tất cả', 'Tổng quan', 'Dịch vụ', 'Tài khoản'];
  final searchHelpFqas = TextEditingController();
  final isSelectedHelp = 0.obs;

  // inital variable manager password
  final passwordNewController = TextEditingController();
  final passwordNewConfirmController = TextEditingController();
  final obscurePasswordNew = true.obs;
  final obscurePasswordNewConfirm = true.obs;

  // initial variable contact us
  final arrowDownService = false.obs;
  final arrowDownWhatsApp = false.obs;
  final arrowDownWebsite = false.obs;
  final arrowDownTwitter = false.obs;
  final arrowDownFacebook = false.obs;
  final arrowDownInstagram = false.obs;

  // infor user
  final Rxn<UserModel> infoUser = Rxn<UserModel>();

  // init
  @override
  void onInit() {
    super.onInit();
    loadUserModel();
  }

  // load user model
  void loadUserModel() async {
    final user = await getUserModel();
    if (user != null) {
      infoUser.value = user;
    }
  }

  // selected item help & FQAs
  void selectedItemHelpFQA(int index) {
    isSelectedHelp.value = index;
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

  // password new visibility
  void togglePasswordNewVisibility() {
    obscurePasswordNew.value = !obscurePasswordNew.value;
  }

  // password new confirm visibility
  void togglePasswordNewConfirmVisibility() {
    obscurePasswordNewConfirm.value = !obscurePasswordNewConfirm.value;
  }

  // clear input email
  void clearInputPhone() {
    usernameController.text = "";
  }

  // Call login from loginService
  Future<void> login() async {
    if (!formKeyLogin.currentState!.validate()) return;

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
          snackPosition: SnackPosition.TOP, colorText: Colors.red);
    }
  }

  // Call logout from loginService
  Future<void> logOut() async {
    final success = await LoginService().logout();
    if (success) {
      Get.snackbar(
        "OK",
        "Đăng xuất thành công!.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: kPrimaryColor.withOpacity(0.1),
        colorText: Colors.green,
      );
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.snackbar(
        "Lỗi",
        "Đăng xuất thất bại!.",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.red,
      );
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
