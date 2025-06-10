import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class StartChatScreen extends StatelessWidget {
  const StartChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Back",
                    style:
                        PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
                  ),
                ),
              ),
              Container(
                width: 30.w,
                height: 10.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(3.w)),
                child: Text(
                  "AI Chat Bot",
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                child: Image.asset(
                  "assets/image/bg_chatbot.jpg",
                ),
              ),
              Container(
                width: 100.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.w),
                    topRight: Radius.circular(5.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Toto biết bạn sẽ thích nó!",
                      style: PrimaryFont.headerTextBold()
                          .copyWith(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.chatbot),
                      child: Container(
                        width: 50.w,
                        height: 12.w,
                        margin: EdgeInsets.symmetric(vertical: 5.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Text(
                          "Start ChatBot",
                          style: PrimaryFont.titleTextMedium()
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedGears,
                          size: 5.w,
                          color: kPrimaryColor,
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          "Chatbot Settings",
                          style: PrimaryFont.titleTextMedium()
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
