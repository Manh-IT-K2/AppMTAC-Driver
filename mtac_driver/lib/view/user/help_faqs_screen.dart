import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/help_faqs_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class HelpFaqsScreen extends StatelessWidget {
  HelpFaqsScreen({super.key});

  final HelpFAQController _helpFAQController = Get.put(HelpFAQController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Help & FAQs",
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _helpFAQController.searchHelpFqas,
                cursorColor: kPrimaryColor.withOpacity(0.6),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: PrimaryFont.bodyTextMedium(),
                  prefixIcon: Icon(
                    HugeIcons.strokeRoundedSearch01,
                    size: 5.w,
                    color: Colors.black,
                  ),
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
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _helpFAQController.helpTitles.length,
                      (index) {
                        final title = _helpFAQController.helpTitles[index];
                        final isSelected =
                            _helpFAQController.isSelectedHelp.value == index;

                        return Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: _itemTitleHelpFQAs(
                            title: title,
                            isSelectedHelp: isSelected,
                            onTap: () {
                              _helpFAQController.selectedItemHelpFQA(index);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Obx(
                () => SizedBox(
                  width: 100.w,
                  height: 70.h,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: _helpFAQController.faqList.length,
                    itemBuilder: (context, index) {
                      final item = _helpFAQController.faqList[index];
                      return Obx(
                        () => _itemHelpFQAsAccount(
                          arrowDownPrivew: item.isExpanded.value,
                          title: item.title,
                          subTitle: item.subTitle,
                          ontap: () => _helpFAQController.toggleExpand(index),
                        ),
                      );
                    },
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

class _itemTitleHelpFQAs extends StatelessWidget {
  const _itemTitleHelpFQAs({
    super.key,
    required this.title,
    required this.isSelectedHelp,
    this.onTap,
  });
  final String title;
  final bool isSelectedHelp;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.w,
        height: 10.w,
        margin: EdgeInsets.symmetric(vertical: 5.w),
        decoration: BoxDecoration(
          color: isSelectedHelp ? kPrimaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Center(
          child: Text(
            title,
            style: PrimaryFont.bodyTextMedium().copyWith(
              color: isSelectedHelp ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _itemHelpFQAsAccount extends StatelessWidget {
  const _itemHelpFQAsAccount({
    super.key,
    required this.arrowDownPrivew,
    required this.title,
    required this.subTitle,
    this.ontap,
  });

  final bool arrowDownPrivew;
  final String title, subTitle;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      //height: arrowDownPrivew ? 40.w : 12.w,
      margin: EdgeInsets.only(bottom: 3.w),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     width: 1,
      //     color: kPrimaryColor.withOpacity(0.4),
      //   ),
      //   borderRadius: BorderRadius.circular(3.w),
      // ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  title,
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
                )),
                GestureDetector(
                  onTap: ontap,
                  child: Icon(
                    arrowDownPrivew
                        ? HugeIcons.strokeRoundedArrowUp01
                        : HugeIcons.strokeRoundedArrowDown01,
                    size: 5.w,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            arrowDownPrivew
                ? Container(
                    width: 100.w,
                    height: 0.2,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(vertical: 3.w),
                  )
                : const SizedBox(),
            arrowDownPrivew
                ? Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            subTitle,
                            // maxLines: 4,
                            // overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: PrimaryFont.bodyTextThin().copyWith(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
