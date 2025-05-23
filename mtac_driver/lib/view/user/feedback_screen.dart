import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

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
                  "Phản hồi",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dánh giá trải nghiệm của bạn",
              style:
                  PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _itemRateExperience(
                    title: "Rất tệ",
                    icon: HugeIcons.strokeRoundedAngry,
                    isSelectedRate: false),
                _itemRateExperience(
                    title: "Tệ",
                    icon: HugeIcons.strokeRoundedSad01,
                    isSelectedRate: false),
                _itemRateExperience(
                    title: "Bình thường",
                    icon: HugeIcons.strokeRoundedMeh,
                    isSelectedRate: false),
                _itemRateExperience(
                    title: "Tốt",
                    icon: HugeIcons.strokeRoundedRelieved01,
                    isSelectedRate: false),
                _itemRateExperience(
                    title: "Rất tốt",
                    icon: HugeIcons.strokeRoundedInLove,
                    isSelectedRate: true),
              ],
            ),
            SizedBox(
              height: 5.w,
            ),
            Text(
              "Bạn thích cái gì?",
              style:
                  PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 3.w,
            ),
            _itemGoodRateChoice(
                title: "Dịch vụ hỗ trợ tốt", isSeletedRateGood: true),
            const Divider(),
            _itemGoodRateChoice(
                title: "Dịch vụ hỗ trợ tốt", isSeletedRateGood: true),
            const Divider(),
            _itemGoodRateChoice(
                title: "Dịch vụ hỗ trợ tốt", isSeletedRateGood: false),
            const Divider(),
            _itemGoodRateChoice(
                title: "Dịch vụ hỗ trợ tốt", isSeletedRateGood: false),
            const Divider(),
            _itemGoodRateChoice(
                title: "Dịch vụ hỗ trợ tốt", isSeletedRateGood: true),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Đóng góp ý kiến của bạn",
              style:
                  PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 3.w,
            ),
            SizedBox(
              width: 100.w,
              child: TextField(
                maxLines: null, 
                minLines: 5,
                cursorColor: kPrimaryColor.withOpacity(0.6),
                decoration: InputDecoration(
                  hintText: "Viết ý kiến của bạn ở đây",
                  hintStyle: PrimaryFont.bodyTextMedium(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), width: 0.1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _itemGoodRateChoice extends StatelessWidget {
  const _itemGoodRateChoice({
    super.key,
    required this.title,
    this.onTap,
    required this.isSeletedRateGood,
  });
  final String title;
  final Function()? onTap;
  final bool isSeletedRateGood;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              color: isSeletedRateGood ? kPrimaryColor : Colors.white,
              shape: BoxShape.circle,
            ),
            child: isSeletedRateGood
                ? Icon(
                    HugeIcons.strokeRoundedTick01,
                    size: 4.w,
                    color: Colors.white,
                  )
                : const SizedBox(),
          ),
        )
      ],
    );
  }
}

class _itemRateExperience extends StatelessWidget {
  const _itemRateExperience({
    super.key,
    required this.title,
    this.onTap,
    required this.isSelectedRate,
    required this.icon,
  });
  final String title;
  final Function()? onTap;
  final bool isSelectedRate;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 10.w,
            height: 10.w,
            margin: EdgeInsets.only(bottom: 2.w, top: 5.w),
            decoration: BoxDecoration(
                color: isSelectedRate
                    ? kPrimaryColor
                    : kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle),
            child: Icon(
              icon,
              size: 5.w,
              color: isSelectedRate ? Colors.white : Colors.black,
            ),
          ),
        ),
        isSelectedRate
            ? Text(
                title,
                style: PrimaryFont.bodyTextMedium().copyWith(
                    color: isSelectedRate ? kPrimaryColor : Colors.black),
              )
            : const SizedBox(),
      ],
    );
  }
}
