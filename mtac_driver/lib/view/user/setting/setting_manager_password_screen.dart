import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/common/button/button_long.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/common/input/input_form.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingManagerPasswordScreen extends StatelessWidget {
  SettingManagerPasswordScreen({super.key});
  // initial ProfileController
  final _profileController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();
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
            key: _formKey,
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
                  () => InputForm(
                    readOnly: false,
                    title: l10n.txtPasswordL,
                    controller: _profileController.passwordOldController,
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
                  child: GestureDetector(
                      onTap: () {
                        _profileController.toggleIsFogotPassVisibility();
                      },
                      child: Icon(
                        HugeIcons.strokeRoundedAlertCircle,
                        size: 4.w,
                        color: Colors.red,
                      )),
                ),
                Obx(
                  () => _profileController.isForgotPass.value
                      ? Text(
                          "Nếu quên mật khẩu, bạn hãy liên hệ với nhà thầu để được cấp lại mật khẩu nha!",
                          style: PrimaryFont.bodyTextMedium()
                              .copyWith(color: Colors.red),
                        )
                      : const SizedBox(),
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
                  () => InputForm(
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
                  () => InputForm(
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
                ButtonLong(
                  title: l10n.txtChangePasswordMP,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      final authFingerprint =
                          await _profileController.authenticateFingerprint(
                              reason: 'Xác thực để cập nhật mật khẩu');
                      if (authFingerprint) {
                        _profileController.updatePassword(
                          {
                            "password": _profileController
                                .passwordNewController.text
                                .trim()
                          },
                        );
                      } else {
                        Get.snackbar(
                            "Thất bại", "Xác thực thất bại hoặc bị hủy",
                            backgroundColor: Colors.red.withOpacity(0.8),
                            colorText: Colors.white);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
