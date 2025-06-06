import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class SettingManagerDriverLisense extends StatelessWidget {
  SettingManagerDriverLisense({super.key});
  final _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarCommon(hasMenu: false, title: "Quản lý GPLX"),
      body: Obx(
        () {
          final user = _profileController.infoUser.value;
          if (user == null) {
            return Center(
              child: Image.asset(
                "assets/image/loadingDot.gif",
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            );
          }
         
          Image imageWidget;
          if (_profileController.imgPath.value.isEmpty) {
            imageWidget = Image.network("${ApiConfig.urlImage}${user.user.imgGplxPath}",
                height: 30.h,);
          } else {
            imageWidget =
                Image.file(File(_profileController.imgPath.value), height: 30.h, fit: BoxFit.cover);
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Giấy phép lái xe",
                      style: PrimaryFont.titleTextMedium()
                          .copyWith(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _profileController.imgPath.value = await Get.toNamed(
                            AppRoutes.settingUpdateDriverLicense);
                      },
                      child: Icon(
                        HugeIcons.strokeRoundedAddCircle,
                        size: 8.w,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 100.w,
                  margin: EdgeInsets.symmetric(vertical: 5.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 4,
                          blurStyle: BlurStyle.outer,
                          offset: Offset(0, 0),
                          color: Colors.black),
                    ],
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.w),
                    child: imageWidget,
                  ),
                ),
                Text(
                  "Thông tin cơ bản",
                  style: PrimaryFont.titleTextMedium()
                      .copyWith(color: Colors.black),
                ),
                SizedBox(
                  height: 1.w,
                ),
                _itemInforDriverLicense(
                  user: user,
                  title: "Tên tài xế: ",
                  content: user.user.name,
                  colorContent: Colors.black,
                ),
                _itemInforDriverLicense(
                  user: user,
                  title: "Ngày xác thực: ",
                  content: "06/06/2025",
                  colorContent: Colors.black,
                ),
                _itemInforDriverLicense(
                  user: user,
                  title: "Ngày xác thực lại: ",
                  content: "06/06/2030",
                  colorContent: Colors.black,
                ),
                _itemInforDriverLicense(
                  user: user,
                  title: "Trạng thái: ",
                  content: "Hợp lệ",
                  colorContent: Colors.green,
                ),
                _itemInforDriverLicense(
                  user: user,
                  title: "Khu vực đăng ký: ",
                  content: "Hà Nội",
                  colorContent: Colors.black,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  width: 100.w,
                  height: 12.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Text(
                    "Cập nhật",
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _itemInforDriverLicense extends StatelessWidget {
  const _itemInforDriverLicense({
    super.key,
    required this.user,
    required this.title,
    required this.colorContent,
    required this.content,
  });

  final UserModel user;
  final String title, content;
  final Color colorContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Row(
        children: [
          Text(
            title,
            style: PrimaryFont.bodyTextMedium()
                .copyWith(color: Colors.black, height: 2),
          ),
          Text(
            content,
            style: PrimaryFont.bodyTextBold()
                .copyWith(color: colorContent, height: 2),
          ),
        ],
      ),
    );
  }
}
