import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/help_faqs_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});

  // initial HelpFAQController
  final _helpFAQController = Get.find<HelpFAQController>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.h,
              ),
              TextField(
                controller: _helpFAQController.searchHelpFqas,
                cursorColor: kPrimaryColor.withOpacity(0.6),
                decoration: InputDecoration(
                  hintText: l10n.txtSearch,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _helpFAQController.helpTitles
                      .map(
                        (title) => _itemTitleHelpFQAs(
                          title: title,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 60.h,
                child: PageView(
                  controller: _helpFAQController.pageController,
                  onPageChanged: _helpFAQController.onPageChanged,
                  children: _helpFAQController.helpTitles.map(
                    (title) {
                      return CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = _helpFAQController.faqList[index];
                                return Obx(
                                  () => _itemHelpFQAsAccount(
                                    arrowDownPrivew: item.isExpanded.value,
                                    title: item.title,
                                    subTitle: item.subTitle,
                                    ontap: () =>
                                        _helpFAQController.toggleExpand(index),
                                  ),
                                );
                              },
                              childCount: _helpFAQController.faqList.length,
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
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
  _itemTitleHelpFQAs({
    super.key,
    required this.title,
  });
  final String title;

  final _helpController = Get.find<HelpFAQController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _helpController.selectedItemHelpFQA(title),
      child: Obx(
        () {
          bool isSelectedHelp =
              _helpController.selectedHelpGeneral.value == title;
          return Container(
            width: 20.w,
            height: 10.w,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 5.w, bottom: 5.w, right: 5.w),
            decoration: BoxDecoration(
              color: isSelectedHelp ? kPrimaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: PrimaryFont.bodyTextMedium().copyWith(
                color: isSelectedHelp ? Colors.white : Colors.black,
              ),
            ),
          );
        },
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
      height: arrowDownPrivew ? 40.w : 12.w,
      margin: EdgeInsets.only(bottom: 3.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: kPrimaryColor.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
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
              ? Text(
                  subTitle,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: PrimaryFont.bodyTextThin().copyWith(
                    color: Colors.black.withOpacity(0.6),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
