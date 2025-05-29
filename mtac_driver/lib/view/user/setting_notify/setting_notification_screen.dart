import 'package:flutter/material.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class SettingNotificationScreen extends StatelessWidget {
  const SettingNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(hasMenu: false, title: "Cài đặt thông báo"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Hãy cho chúng tôi biết loại thông báo bạn muốn nhận trên thiết bị này. Bạn có thể thay đổi thông báo này bất kỳ lúc nào.",
              style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5.w,
            ),
            const _itemSettingNotify(
              enableStatus: true,
              title:  "Lịch thu gom",
              subTitle: "Hiển thị những thông báo cho các chuyến thu gom khi hoàn thành chuyến gom.",
            ),
             const Divider(),
             const _itemSettingNotify(
              enableStatus: false,
              title:  "Nhắc nhở",
              subTitle: "Hiển thị những thông báo nhắc nhở bạn khi bạn quên cập nhật app, mở vị trí,...",
            ),
             const Divider(),
             const _itemSettingNotify(
              enableStatus: false,
              title:  "Hoạt động của bạn",
              subTitle: "Hiển thị những thông báo về những hoạt động của bạn như: tài khoản được thiết lập, thông tin cá nhân được thay đổi,...",
            ),
          ],
        ),
      ),
    );
  }
}

class _itemSettingNotify extends StatelessWidget {
  const _itemSettingNotify({
    super.key, required this.title, required this.subTitle, required this.enableStatus,
  });
  final String title, subTitle;
  final bool enableStatus;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.w,),
              Text(
               title,
                style: PrimaryFont.titleTextBold()
                    .copyWith(color: Colors.black),
              ),
              Text(
                subTitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: PrimaryFont.bodyTextMedium()
                    .copyWith(color: Colors.black, height: 1.5),
              ),
            ],
          ),
        ),
        Container(
          width: 16.w,
          height: 8.w,
          margin: EdgeInsets.only(left: 5.w),
          decoration: BoxDecoration(
            color: enableStatus ? kPrimaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Align(
            alignment: enableStatus ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 8.w,
              height: 8.w,
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
          ),
        ),
       
      ],
    );
  }
}
