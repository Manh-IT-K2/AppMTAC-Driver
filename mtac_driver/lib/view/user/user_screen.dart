import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:mtac_driver/widgets/user_widget/input_form_widget.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// @override
// void initState() {
//   initState();
//   final apiConfig = ApiConfig();
//   apiConfig.checkServerStatus().then((isOnline) {
//     if (isOnline) {
//       if (kDebugMode) {
//         print("Server OK");
//       }
//     } else {
//       if (kDebugMode) {
//         print("Server không hoạt động");
//       }
//     }
//   });
// }

//
final controller = Get.put(LoginController(), permanent: true);

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKeyLogin,
              child: Column(
                children: [
                  SizedBox(height: 20.w),
                  Text(
                    "Welcom to",
                    style: PrimaryFont.bold(10.w).copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    "MTAC-Driver",
                    style: PrimaryFont.titleTextBold().copyWith(
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  InputFormWidget(
                    title: 'Phone number',
                    obscureText: false,
                    controller: controller.emailController,
                    iconStart: HugeIcons.strokeRoundedCall02,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: IconButton(
                      icon: const Icon(HugeIcons.strokeRoundedCancel01),
                      iconSize: 5.w,
                      onPressed: controller.clearTextEmail,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Số điện thoại chỉ được chứa số';
                      }
                      if (value.length < 9) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5.w),
                  Obx(
                    () => InputFormWidget(
                      title: 'Password',
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      iconStart: HugeIcons.strokeRoundedLockPassword,
                      suffixIcon: IconButton(
                        icon: Icon(controller.obscurePassword.value
                            ? HugeIcons.strokeRoundedView
                            : HugeIcons.strokeRoundedViewOff),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng nhập password'
                          : null,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Forgot password?",
                        style: PrimaryFont.bodyTextMedium()
                            .copyWith(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: 100.w,
                            child: ElevatedButton(
                              onPressed: () {},
                              //onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.w),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              child: Text(
                                "Sign in",
                                style: PrimaryFont.bodyTextMedium().copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    "----- Or register by call -----",
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 15.w),
                  Text(
                    "1900.8080.2020",
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: kPrimaryColor),
                  ),
                  SizedBox(height: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "By logging in, you accept",
                        style: PrimaryFont.bodyTextMedium()
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(width: 1.w),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "terms of use",
                          style: PrimaryFont.bodyTextMedium()
                              .copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
