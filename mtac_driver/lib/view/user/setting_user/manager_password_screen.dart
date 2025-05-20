import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/user_widget/input_form_widget.dart';
import 'package:sizer/sizer.dart';

class ManagerPasswordScreen extends StatelessWidget {
  ManagerPasswordScreen({super.key});
  final _loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SizedBox(
          width: 100.w,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  HugeIcons.strokeRoundedArrowLeft01,
                  size: 8.w,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  "Quản lí mật khẩu",
                  textAlign: TextAlign.center,
                  style: PrimaryFont.headerTextBold()
                      .copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mật khẩu hiện tại",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 3.w,
              ),
              Obx(
                () => InputFormWidget(
                  readOnly: false,
                  title: 'Password',
                  controller: _loginController.passwordController,
                  obscureText: _loginController.obscurePassword.value,
                  iconStart: HugeIcons.strokeRoundedLockPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_loginController.obscurePassword.value
                        ? HugeIcons.strokeRoundedView
                        : HugeIcons.strokeRoundedViewOff),
                    onPressed: _loginController.togglePasswordVisibility,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập password'
                      : null,
                ),
              ),
              SizedBox(
                height: 3.w,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Quên mật khẩu?",
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: kPrimaryColor),
                ),
              ),
              SizedBox(
                height: 3.w,
              ),
              Text(
                "Mật khẩu mới",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 3.w,
              ),
              Obx(
                () => InputFormWidget(
                  readOnly: false,
                  title: 'Password',
                  controller: _loginController.passwordNewController,
                  obscureText: _loginController.obscurePasswordNew.value,
                  iconStart: HugeIcons.strokeRoundedLockPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_loginController.obscurePasswordNew.value
                        ? HugeIcons.strokeRoundedView
                        : HugeIcons.strokeRoundedViewOff),
                    onPressed: _loginController.togglePasswordNewVisibility,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập password'
                      : null,
                ),
              ),
              SizedBox(
                height: 3.w,
              ),
              Text(
                "Xác nhận mật khẩu mới",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 3.w,
              ),
              Obx(
                () => InputFormWidget(
                  readOnly: false,
                  title: 'Password',
                  controller: _loginController.passwordNewConfirmController,
                  obscureText: _loginController.obscurePasswordNewConfirm.value,
                  iconStart: HugeIcons.strokeRoundedLockPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_loginController.obscurePasswordNewConfirm.value
                        ? HugeIcons.strokeRoundedView
                        : HugeIcons.strokeRoundedViewOff),
                    onPressed:
                        _loginController.togglePasswordNewConfirmVisibility,
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Vui lòng nhập password'
                      : null,
                ),
              ),
              SizedBox(
                height: 25.w,
              ),
              SizedBox(
                width: 100.w,
                child: ElevatedButton(
                  onPressed: () {
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
                    "Đổi mật khẩu",
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
    );
  }
}
