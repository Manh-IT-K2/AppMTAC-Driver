import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/common/input/input_form_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManagerPasswordScreen extends StatelessWidget {
  ManagerPasswordScreen({super.key});
  final _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarCommon(hasMenu: false, title: l10n.txtPasswordManagementSU),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _profileController.formKeyChangePass,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/image/image_change_password.jpg",
                  width: 100.w,
                  height: 25.h,
                ),
                SizedBox(
                  height: 5.w,
                ),
                Text(
                  l10n.txtCurrentPasswordMP,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.black),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Obx(
                  () => InputFormWidget(
                    readOnly: false,
                    title: l10n.txtPasswordL,
                    controller: _profileController.passwordController,
                    obscureText: _profileController.obscurePassword.value,
                    iconStart: HugeIcons.strokeRoundedLockPassword,
                    suffixIcon: IconButton(
                      icon: Icon(_profileController.obscurePassword.value
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOff),
                      onPressed: _profileController.togglePasswordVisibility,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.txtPleaseEnPassL
                        : null,
                  ),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    l10n.txtForgotPassL,
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: kPrimaryColor),
                  ),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Text(
                  l10n.txtNewPasswordMP,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.black),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Obx(
                  () => InputFormWidget(
                    readOnly: false,
                    title: l10n.txtPasswordL,
                    controller: _profileController.passwordNewController,
                    obscureText: _profileController.obscurePasswordNew.value,
                    iconStart: HugeIcons.strokeRoundedLockPassword,
                    suffixIcon: IconButton(
                      icon: Icon(_profileController.obscurePasswordNew.value
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOff),
                      onPressed: _profileController.togglePasswordNewVisibility,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.txtPleaseEnPassL
                        : null,
                  ),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Text(
                  l10n.txtConfirmPasswordMP,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.black),
                ),
                SizedBox(
                  height: 3.w,
                ),
                Obx(
                  () => InputFormWidget(
                      readOnly: false,
                      title: l10n.txtPasswordL,
                      controller:
                          _profileController.passwordNewConfirmController,
                      obscureText:
                          _profileController.obscurePasswordNewConfirm.value,
                      iconStart: HugeIcons.strokeRoundedLockPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _profileController.obscurePasswordNewConfirm.value
                                ? HugeIcons.strokeRoundedView
                                : HugeIcons.strokeRoundedViewOff),
                        onPressed: _profileController
                            .togglePasswordNewConfirmVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.txtPleaseEnPassL;
                        } else if (value !=
                            _profileController.passwordNewController.text) {
                          return l10n.txtErrNotMatchL;
                        }
                        return null;
                      }),
                ),
                SizedBox(
                  height: 15.w,
                ),
                SizedBox(
                  width: 100.w,
                  child: ElevatedButton(
                    onPressed: () {
                      _profileController.updatePassword(
                        {
                          "password": _profileController
                              .passwordNewController.text
                              .trim()
                        },
                      );
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
                      l10n.txtChangePasswordMP,
                      style: PrimaryFont.bodyTextMedium().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
