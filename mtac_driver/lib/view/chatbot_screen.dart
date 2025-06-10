import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(hasMenu: false, title: "Toto Chatbot"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  margin: EdgeInsets.only(right: 2.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Image.asset(
                    "assets/image/avt_chatbot.png",
                    width: 10.w,
                    height: 10.w,
                  ),
                ),
                Container(
                  height: 10.w,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2.w),
                      bottomLeft: Radius.circular(5.w),
                      bottomRight: Radius.circular(2.w),
                    ),
                  ),
                  child: Text(
                    "Hello! Can I help you?",
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 40.w,
                height: 10.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.w),
                    bottomLeft: Radius.circular(2.w),
                    bottomRight: Radius.circular(5.w),
                  ),
                ),
                child: Text(
                  "Hello! Can I help you?",
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            TextFormField(
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: PrimaryFont.bodyTextMedium(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: Icon(
                  HugeIcons.strokeRoundedSent,
                  size: 6.w,
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
