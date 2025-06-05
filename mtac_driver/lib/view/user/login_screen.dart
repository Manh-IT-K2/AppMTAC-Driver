import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/common/input/input_form_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

@override
void initState() {
  initState();
  final apiConfig = ApiConfig();
  apiConfig.checkServerStatus().then((isOnline) {
    if (isOnline) {
      if (kDebugMode) {
        print("Server OK");
      }
    } else {
      if (kDebugMode) {
        print("Server không hoạt động");
      }
    }
  });
}

//
final controller = Get.find<LoginController>();

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Obx(
                () => controller.isLoading.value
                    ? Image.asset(
                        "assets/image/loadingDot.gif",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        children: [
                          SizedBox(height: 20.w),
                          Text(
                            l10n.txtWelcomToL,
                            style: PrimaryFont.headerTextBold().copyWith(
                              color: kPrimaryColor,
                            ),
                          ),
                          Text(
                            "MTAC-Driver",
                            style: PrimaryFont.textCustomBold(8.w).copyWith(
                              color: kPrimaryColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          InputFormWidget(
                            readOnly: false,
                            title: l10n.txtPhone,
                            obscureText: false,
                            controller: controller.usernameController,
                            iconStart: HugeIcons.strokeRoundedCall02,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            suffixIcon: IconButton(
                              icon: const Icon(HugeIcons.strokeRoundedCancel01),
                              iconSize: 5.w,
                              onPressed: controller.clearInputPhone,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.txtPleaseEnPhoneL;
                              }
                              if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return l10n.txtErrOnlyNumberL;
                              }
                              if (value.length < 9) {
                                return l10n.txtErrNotValidPhoneL;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 5.w),
                          InputFormWidget(
                            readOnly: false,
                            title: l10n.txtPasswordL,
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
                                ? l10n.txtPleaseEnPassL
                                : null,
                          ),
                          SizedBox(height: 5.w),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                l10n.txtForgotPassL,
                                style: PrimaryFont.bodyTextMedium()
                                    .copyWith(color: kPrimaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.w),
                          SizedBox(
                            width: 100.w,
                            child: ElevatedButton(
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  controller.login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.w),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.3),
                              ),
                              child: Text(
                                l10n.txtSignInL,
                                style: PrimaryFont.bodyTextMedium().copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.w),
                          Text(
                            "----- ${l10n.txtOrRegisterByCallL} -----",
                            style: PrimaryFont.bodyTextMedium()
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(height: 15.w),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                HugeIcons.strokeRoundedCall02,
                                color: kPrimaryColor,
                                size: 5.w,
                              ),
                              Text(
                                "1900.545.450",
                                style: PrimaryFont.titleTextBold()
                                    .copyWith(color: kPrimaryColor),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.w),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.txtByLoggingInYouAcceptL,
                                style: PrimaryFont.bodyTextMedium()
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(width: 1.w),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  l10n.txtTermsOfUseL,
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
      ),
    );
  }
}
