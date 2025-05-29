import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  final loginController = Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
    //
    final l10n = AppLocalizations.of(context)!;
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
                              borderRadius: BorderRadius.circular(
                                3.w,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3.w,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 18.w,
                                height: 18.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(238, 238, 238, 1),
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
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      l10n.txtMyProfileAU,
                                      style: PrimaryFont.bodyTextBold()
                                          .copyWith(color: kPrimaryColor),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>() => loginController.logOut(),
                                child: Container(
                                  width: 50.w - 16,
                                  height: 10.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100.w),
                                      bottomRight: Radius.circular(30.w),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                     l10n.txtLogoutAU,
                                      style: PrimaryFont.bodyTextBold()
                                          .copyWith(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 5.w,
              ),
              _ItemFuncAccount(
                title: l10n.txtSettingAU,
                arrowRight: true,
                onTap: () {
                  Get.toNamed(AppRoutes.setting);
                },
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedSetting07,
              ),
              const Divider(),
              _ItemFuncAccount(
                title: l10n.txFeedBackAU,
                arrowRight: true,
                onTap: () => Get.toNamed(AppRoutes.feedback),
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedComment02,
              ),
              const Divider(),
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
                      l10n.txtLanguageAU,
                      style: PrimaryFont.bodyTextMedium()
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final newLang = loginController.isEnglish ? 'vi' : 'en';
                      loginController.changeLanguage(newLang);
                    },
                    child: Container(
                      width: 10.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        color: loginController.isEnglish ? kPrimaryColor : Colors.grey[400],
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Obx(
                        () => Align(
                          alignment: loginController.isEnglish
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 5.w,
                            height: 4.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                loginController.isEnglish ? "en" : "vi",
                                textAlign: TextAlign.center,
                                style: PrimaryFont.bold(2.w)
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              _ItemFuncAccount(
                title: l10n.txtContactAU,
                arrowRight: true,
                onTap: () {
                  Get.toNamed(AppRoutes.contactUs);
                },
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedCalling02,
              ),
              const Divider(),
              _ItemFuncAccount(
                title: l10n.txtPrivacyAU,
                arrowRight: true,
                onTap: () {
                  Get.toNamed(AppRoutes.privacyPolicy);
                },
                color: kPrimaryColor,
                icon: HugeIcons.strokeRoundedBlocked,
              ),
              const Divider(),
              SizedBox(
                height: 10.w,
              ),
              Text(
                "${l10n.txtVersionAU} 1.1.1 build 1110",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _itemButHeaderAccount extends StatelessWidget {
  const _itemButHeaderAccount({
    super.key,
    required this.l10n,
    this.onTap,
    required this.title,
    required this.color,
  });

  final AppLocalizations l10n;
  final Function()? onTap;
  final String title;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w - 16,
        height: 10.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.w),
            topRight: Radius.circular(100.w),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: PrimaryFont.bodyTextBold().copyWith(color: color),
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
                borderRadius: BorderRadius.circular(2.w),
              ),
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
