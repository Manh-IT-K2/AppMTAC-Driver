import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  "Cài đặt",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _itemSettingAccount(
              title: "Cài đặt thông báo",
              icon: HugeIcons.strokeRoundedNotification03,
              ontap: () {},
            ),
            _itemSettingAccount(
              title: "Quản lý mật khẩu",
              icon: HugeIcons.strokeRoundedForgotPassword,
              ontap: () {},
            ),
            _itemSettingAccount(
              title: "Xoá tài khoản",
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
  });
  final String title;
  final Function()? ontap;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.w),
      child: Row(
        children: [
          Icon(
            icon,
            size: 5.w,
            color: Colors.black,
          ),
          SizedBox(
            width: 3.w,
          ),
          Expanded(
            child: Text(
              title,
              style: PrimaryFont.bodyTextMedium(),
            ),
          ),
          GestureDetector(
            onTap: ontap,
            child: Icon(
              HugeIcons.strokeRoundedArrowRight01,
              size: 5.w,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
