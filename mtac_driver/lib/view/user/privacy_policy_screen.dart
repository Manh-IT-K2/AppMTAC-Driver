import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                  "Chính sách bảo mật",
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "APP: MTAC - DRIVER",
                textAlign: TextAlign.center,
                style:
                    PrimaryFont.titleTextBold().copyWith(color: kPrimaryColor),
              ),
              SizedBox(
                height: 5.w,
              ),
              Row(
                children: [
                  Text(
                    "Update on Apr 5, 2024 | 30 min read",
                    textAlign: TextAlign.center,
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  Icon(
                    HugeIcons.strokeRoundedHourglass,
                    size: 5.w,
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                ],
              ),
              SizedBox(
                height: 3.w,
              ),
              Text(
                "Last update: 26 May 2025",
                textAlign: TextAlign.center,
                style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
              ),
              const SectionTitle('1. Thông tin chúng tôi thu thập'),
              const SectionBody(
                  '• Họ tên, số điện thoại, địa chỉ, email\n• Vị trí hiện tại\n• Lịch sử thu gom, thời gian hoạt động\n• Hình ảnh hoặc dữ liệu đính kèm (nếu có)'),
              const SectionTitle('2. Mục đích sử dụng thông tin'),
              const SectionBody(
                  '• Hỗ trợ và tối ưu lộ trình\n• Gửi thông báo, nhắc lịch\n• Cải thiện trải nghiệm người dùng\n• Bảo mật và chống gian lận'),
              const SectionTitle('3. Chia sẻ thông tin'),
              const SectionBody(
                  '• Không chia sẻ cho bên thứ ba trừ khi có sự đồng ý\n• Theo yêu cầu pháp luật\n• Với đối tác kỹ thuật có cam kết bảo mật'),
              const SectionTitle('4. Bảo mật thông tin'),
              const SectionBody(
                  '• Áp dụng biện pháp kỹ thuật bảo vệ dữ liệu\n• Tuy nhiên, không thể đảm bảo an toàn tuyệt đối'),
              const SectionTitle('5. Quyền của người dùng'),
              const SectionBody(
                  '• Truy cập, chỉnh sửa, xóa thông tin\n• Rút lại sự đồng ý\n• Gửi phản hồi hoặc khiếu nại'),
              const SectionTitle('6. Thay đổi chính sách'),
              const SectionBody(
                  '• Chính sách có thể thay đổi, bạn sẽ được thông báo\n• Tiếp tục sử dụng ứng dụng đồng nghĩa bạn đồng ý'),
              const SectionTitle('7. Liên hệ'),
              const SectionBody(
                  '• Email: info@moitruongachau.com\n• Số điện thoại: 1900 545450\n• Địa chỉ: 404 Đường Tân Sơn Nhì, P. Tân Quý, Q. Tân Phú, Tp. Hồ Chí Minh'),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.w),
      child: Text(
        text,
        style: PrimaryFont.titleTextBold().copyWith(color: Colors.black),
      ),
    );
  }
}

class SectionBody extends StatelessWidget {
  final String text;
  const SectionBody(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          PrimaryFont.bodyTextMedium().copyWith(color: Colors.black, height: 2),
    );
  }
}
