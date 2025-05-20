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
                  return SizedBox(
                    width: 100.w - 32,
                    height: 20.h,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 100.w - 32,
                            height: 15.h,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(238, 238, 238, 1),
                                borderRadius: BorderRadius.circular(3.w)),
                          ),
                        ),
                        Center(
                          child: Positioned(
                            top: 3.w,
                            child: Column(
                              children: [
                                Container(
                                  width: 18.w,
                                  height: 18.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          238, 238, 238, 1),
                                      width: 5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(child: buildAvatar(user)),
                                ),
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
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.profile),
                                child: Container(
                                  width: 50.w - 16,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30.w),
                                      topRight: Radius.circular(100.w),
                                      // bottomRight: Radius.circular(3.w),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "MY PROFILE",
                                      style: PrimaryFont.bodyTextBold()
                                          .copyWith(color: kPrimaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => loginController.logOut(),
                                child: Container(
                                  width: 50.w - 16,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.w),
                                      //topLeft: Radius.circular(3.w),
                                      bottomLeft: Radius.circular(100.w),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "LOGOUT",
                                      textAlign: TextAlign.center,
                                      style: PrimaryFont.bodyTextBold()
                                          .copyWith(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 5.w,
              ),
              // _ItemFuncAccount(
              //   title: "My Profile",
              //   arrowRight: true,
              //   color: kPrimaryColor,
              //   onTap: () => Get.toNamed(AppRoutes.profile),
              //   icon: HugeIcons.strokeRoundedUser,
              // ),
              //const Divider(),
              const _ItemFuncAccount(
                title: "Payment Methods",
                arrowRight: true,
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedCreditCardValidation,
              ),
              const Divider(),
              _ItemFuncAccount(
                title: "Contact Us",
                arrowRight: true,
                onTap: () {
                  Get.toNamed(AppRoutes.contactUs);
                },
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedCalling02,
              ),
              const Divider(),
              _ItemFuncAccount(
                title: "Help & FAQs",
                arrowRight: true,
                onTap: () {
                  Get.toNamed(AppRoutes.helpFaqs);
                },
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedBot,
              ),
              const Divider(),
              _ItemFuncAccount(
                title: "Settings",
                arrowRight: true,
                onTap: () {
                  Get.toNamed(AppRoutes.setting);
                },
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedSetting07,
              ),
              const Divider(),
              // _ItemFuncAccount(
              //   title: "Logout",
              //   arrowRight: false,
              //   color: Colors.red,
              //   icon: HugeIcons.strokeRoundedLogin03,
              //   onTap: () => loginController.logOut(),
              // ),
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(2.w)),
                    child: Icon(
                      HugeIcons.strokeRoundedLanguageSkill,
                      size: 5.w,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Text(
                      "Language",
                      style: PrimaryFont.bodyTextMedium()
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: 10.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 5.w,
                        height: 4.w,
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "vi",
                            textAlign: TextAlign.center,
                            style: PrimaryFont.bodyTextMedium()
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const Divider(),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "Phiên bản 1.1.1 build 1110",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.grey),
              )
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
    this.onTap,
    required this.color,
    required this.arrowRight,
  });
  final String title;
  final IconData icon;
  final Color color;
  final Function()? onTap;
  final bool arrowRight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.w),
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
            Expanded(
              child: Text(
                title,
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
              ),
            ),
            arrowRight
                ? Icon(
                    HugeIcons.strokeRoundedArrowRight01,
                    size: 5.w,
                    color: Colors.black,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
