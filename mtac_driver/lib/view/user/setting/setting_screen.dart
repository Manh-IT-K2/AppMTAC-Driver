import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCommon(hasMenu: false, title: l10n.txtSettingAU),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _itemSettingAccount(
              title: l10n.txtSettingNotifiSU,
              arrowRight: true,
              color: Colors.black,
              icon: HugeIcons.strokeRoundedNotification03,
              ontap: () {
                Get.toNamed(AppRoutes.settingNotify);
              },
            ),
            _itemSettingAccount(
              title: "Thiết lập vị trí",
              arrowRight: true,
              color: Colors.black,
              icon: HugeIcons.strokeRoundedLocation01,
              ontap: () {
                Get.toNamed(AppRoutes.settingLocation);
              },
            ),
            _itemSettingAccount(
              title: l10n.txtPasswordManagementSU,
              arrowRight: true,
              color: Colors.black,
              icon: HugeIcons.strokeRoundedForgotPassword,
              ontap: () {
                Get.toNamed(AppRoutes.managerPassword);
              },
            ),
             _itemSettingAccount(
              title: "Quản lý  hợp đồng",
              arrowRight: true,
              color: Colors.black,
              icon: HugeIcons.strokeRoundedLegalHammer,
              ontap: () {},
            ),
            _itemSettingAccount(
              title: l10n.txtDeleteAcountSU,
              arrowRight: false,
              color: Colors.red,
              icon: HugeIcons.strokeRoundedUserRemove01,
              ontap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _itemSettingAccount extends StatelessWidget {
  const _itemSettingAccount({
    super.key,
    required this.title,
    this.ontap,
    required this.icon,
    this.color,
    required this.arrowRight,
  });
  final String title;
  final Function()? ontap;
  final IconData icon;
  final Color? color;
  final bool arrowRight;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.w),
        child: Row(
          children: [
            Icon(
              icon,
              size: 5.w,
              color: color,
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Text(
                title,
                style: PrimaryFont.bodyTextMedium().copyWith(color: color),
              ),
            ),
            arrowRight
                ? Icon(
                    HugeIcons.strokeRoundedArrowRight01,
                    size: 5.w,
                    color: color,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
