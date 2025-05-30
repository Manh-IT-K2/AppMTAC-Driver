import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/controller/user/help_faqs_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final _controller = Get.find<HelpFAQController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarCommon(hasMenu: false, title: "Phản hồi"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đánh giá trải nghiệm của bạn",
                style:
                    PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    _controller.rate.length,
                    (index) {
                      final title = _controller.rate[index];
                      final icon = _controller.iconRate[index];
                      final isSelected =
                          _controller.isSellectedRate.value == index;
                      return _itemRateExperience(
                        title: title,
                        isSelectedRate: isSelected,
                        onTap: () {
                          _controller.sellectedItemRate(index);
                        },
                        icon: icon,
                      );
                    },
                  ),
                ),
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
              Obx(
                () => Column(
                  children: List.generate(
                    _controller.goodRate.length,
                    (index) {
                      final title = _controller.goodRate[index];
                      final selected =
                          _controller.selectedRateIndices.contains(index);
                      return _itemGoodRateChoice(
                        title: title,
                        isSeletedRateGood: selected,
                        onTap: () => _controller.toggleSelectedRateGood(index),
                      );
                    },
                  ),
                ),
              ),
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 100.w,
                  height: 10.w,
                  margin: EdgeInsets.only(top: 10.w),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Center(
                    child: Text(
                      "Gửi",
                      textAlign: TextAlign.center,
                      style: PrimaryFont.bodyTextBold()
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    return Column(
      children: [
        Row(
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
        ),
        const Divider(),
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
