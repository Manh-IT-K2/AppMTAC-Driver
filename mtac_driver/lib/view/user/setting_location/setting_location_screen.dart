import 'package:flutter/material.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class SettingLocationScreen extends StatelessWidget {
  const SettingLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(hasMenu: false, title: "Thiết lập vị trí"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhiều hệ thống định vị vệ tinh(GPS, Bắc đẩu, GLONASS, Galileo) được hỗ trợ.",
              style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5.w,
            ),
            const _itemSettingLocation(
              enableStatus: true,
              title: "Truy cập vị trí",
              subTitle:
                  "Cho phép ứng dựng có quyền này để có thể nhận thông tin vị trí của bạn.",
            ),
            const Spacer(),
            Text(
              'Khi chế độ cài đặt "Độ chính xác của vị trí" đang bật, các ứng dụng và dịch vụ sẽ có được thông tin vị trí chính xác hơn. '
              'Để thực hiện việc này, Google định kỳ xử lý thông tin về cảm biến thiết bị và tín hiệu không dây từ thiết bị của bạn đến các dịch vụ vị trí '
              'dựa trên tín hiệu không dây từ nguồn lực cộng đồng. Những thông tin này sẽ được sử dụng theo cách không xác định danh tính của bạn nhằm cải thiện '
              'độ chính xác của vị trí và các dịch vụ dựa trên vị trí. Ngoài ra, những thông tin này còn dùng để cải thiện, cung cấp và duy trì các dịch vụ của Google '
              'căn cứ trên lợi ích chính đáng của Google và bên thứ ba nhằm phục vụ nhu cầu của người dùng.\n\n'
              'Những ứng dụng có quyền đối với các Thiết bị ở gần có thể xác định vị trí tương đối của các thiết bị đã kết nối.',
              textAlign: TextAlign.justify,
              style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5.w,
            ),
            Text(
              "Tìm hiểu thêm về chế độ Cài đặt vị trí.",
              style: PrimaryFont.titleTextBold().copyWith(
                color: kPrimaryColor,
                decoration: TextDecoration.underline,
                decorationColor: kPrimaryColor,
                decorationThickness: 2
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}

class _itemSettingLocation extends StatelessWidget {
  const _itemSettingLocation({
    super.key,
    required this.title,
    required this.subTitle,
    required this.enableStatus,
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
              SizedBox(
                height: 3.w,
              ),
              Text(
                title,
                style:
                    PrimaryFont.titleTextBold().copyWith(color: Colors.black),
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
          width: 12.w,
          height: 6.w,
          margin: EdgeInsets.only(left: 5.w),
          decoration: BoxDecoration(
            color: enableStatus ? kPrimaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Align(
            alignment:
                enableStatus ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 6.w,
              height: 6.w,
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
