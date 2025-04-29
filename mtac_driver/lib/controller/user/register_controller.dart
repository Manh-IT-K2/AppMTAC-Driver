// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RegisterController extends GetxController {
//   // initial variable
//   final formKeyRegister = GlobalKey<FormState>();

//   final usernameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();

//   // preview/behind password
//   var obscurePassword = true.obs;
//   var obscureConfirmPassword = true.obs;

//   //
//   final isLoading = false.obs;

//   // validate email
//   final isValidateEmail = false.obs;

//   // validate email
//   final isValidatePassword = false.obs;

//   void togglePasswordVisibility() {
//     obscurePassword.value = !obscurePassword.value;
//   }

//   void toggleConfirmPasswordVisibility() {
//     obscureConfirmPassword.value = !obscureConfirmPassword.value;
//   }

//   // Call register from RegisterService
//   Future<void> register() async {
//     if (!formKeyRegister.currentState!.validate()) return;

//     isLoading.value = true;

//     final success = await RegisterService().register(
//       name: usernameController.text.trim(),
//       email: emailController.text.trim(),
//       password: passwordController.text,
//       confirmPassword: confirmPasswordController.text,
//     );

//     isLoading.value = false;

//     if (success) {
//       Get.snackbar("Thành công", "Đăng ký thành công!",
//           snackPosition: SnackPosition.TOP, colorText: Colors.green);
//       Get.toNamed(AppRoutes.login);
//     } else {
//       Get.snackbar("Lỗi", "Đăng ký thất bại. Vui lòng kiểm tra lại.",
//           snackPosition: SnackPosition.TOP);
//     }
//   }

//   // Call check validate email from RegisterService
//   Future<void> validateEmail(String email) async {
//     if (email.isEmpty) {
//       isValidateEmail.value = false;
//       return;
//     }
//     final response = await RegisterService().validateEmail(email);
//     isValidateEmail.value = response;
//   }

//   // Call check validate email from RegisterService
//   Future<void> validatePassword(String password) async {
//     if (password.isEmpty) {
//       isValidatePassword.value = false;
//       return;
//     }
//     final response = await RegisterService().validatePassword(password);
//     isValidatePassword.value = response;
//   }

//   @override
//   void onClose() {
//     usernameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.onClose();
//   }
// }
