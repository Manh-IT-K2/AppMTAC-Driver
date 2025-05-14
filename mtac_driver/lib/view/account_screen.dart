import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
import 'package:sizer/sizer.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Obx(
                () {
                  final user = loginController.infoUser.value;
                  if (user == null) {
                    return Image.asset(
                      "assets/image/loadingDot.gif",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    );
                  }
                  return Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kPrimaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: buildAvatar(user)
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.user.name,
                            style: PrimaryFont.titleTextBold()
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            user.user.email,
                            style: PrimaryFont.bodyTextBold()
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 5.w,
              ),
              _ItemFuncAccount(
                title: "My Profile",
                color: kPrimaryColor,
                onTap: () => Get.toNamed(AppRoutes.profile),
                icon: HugeIcons.strokeRoundedUser,
              ),
              const Divider(),
              const _ItemFuncAccount(
                title: "Payment Methods",
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedCreditCardValidation,
              ),
              const Divider(),
              const _ItemFuncAccount(
                title: "Contact Us",
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedCalling02,
              ),
              const Divider(),
              const _ItemFuncAccount(
                title: "Help & FAQs",
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedBot,
              ),
              const Divider(),
               const _ItemFuncAccount(
                title: "Settings",
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedSetting07,
              ),
              const Divider(),
              _ItemFuncAccount(
                title: "Logout",
                color: Colors.red,
                icon: HugeIcons.strokeRoundedLogin03,
                onTap: () => loginController.logOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemFuncAccount extends StatelessWidget {
  const _ItemFuncAccount({
    super.key,
    required this.title,
    required this.icon,
    this.onTap, required this.color,
  });
  final String title;
  final IconData icon;
  final Color color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.circular(2.w)),
              child: Icon(
                icon,
                color: color,
                size: 5.w,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              title,
              style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
