import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScheduleHistoryScreen extends StatelessWidget {
  ScheduleHistoryScreen({super.key});
  final _scheduleController = Get.find<ScheduleController>();
  @override
  Widget build(BuildContext context) {
    // initial AppLocalizations
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCommon(hasMenu: false, title: l10n.txtTitleSH),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(
              () {
                final isSelected =
                    _scheduleController.isSelectedFilScheduleHistory.value;
                final dateFormatted = DateFormat('dd/MM/yyyy')
                    .format(_scheduleController.isDayScheduleHistory.value);
                return Row(
                  children: [
                    Text(
                      "Tổng hợp",
                      style: PrimaryFont.titleTextMedium()
                          .copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        _scheduleController.selectFilterScheduleHistory(0);
                        _scheduleController.getListScheduleHistory();
                      },
                      child: Container(
                        width: 12.w,
                        height: 8.w,
                        margin: EdgeInsets.only(right: 3.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected == 0 ? kPrimaryColor : Colors.white,
                          border: Border.all(
                              color: isSelected == 0
                                  ? Colors.transparent
                                  : Colors.black,
                              width: 1),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Text(
                          "Tất cả",
                          style: PrimaryFont.bodyTextMedium().copyWith(
                              color: isSelected == 0
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _scheduleController.isDayScheduleHistory.value =
                            (await showDatePicker(
                                  context: context,
                                  initialDate: _scheduleController
                                      .isDayScheduleHistory.value,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                  helpText: 'Chọn ngày',
                                  cancelText: 'Hủy',
                                  confirmText: 'Xác nhận',
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary:
                                              kPrimaryColor, // Màu tiêu đề, chọn ngày
                                          onPrimary: Colors
                                              .white, // Màu chữ trên primary
                                          onSurface: Colors
                                              .black, // Màu chữ ngày tháng
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                kPrimaryColor, // Màu nút "Hủy", "Xác nhận"
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                )) ??
                                DateTime.now();
                        _scheduleController.selectFilterScheduleHistory(1);
                        _scheduleController.getListScheduleHistory(
                            filterDate:
                                _scheduleController.isDayScheduleHistory.value);
                      },
                      child: Container(
                        width: 30.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isSelected == 1 ? kPrimaryColor : Colors.white,
                          border: Border.all(
                              color: isSelected == 1
                                  ? Colors.transparent
                                  : Colors.black,
                              width: 1),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              isSelected == 1 ? dateFormatted : "Chọn ngày",
                              style: PrimaryFont.bodyTextMedium().copyWith(
                                  color: isSelected == 1
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Icon(
                              HugeIcons.strokeRoundedCalendar03,
                              size: 5.w,
                              color:
                                  isSelected == 1 ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 5.w,
            ),
            Obx(
              () {
                final list = _scheduleController.historySchedules;
                if (_scheduleController.isLoadingScheduleHistory.value) {
                  return Expanded(
                    child: Center(
                      child: Image.asset(
                        "assets/image/loadingDot.gif",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return _scheduleController.historySchedules.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "Không có lịch nào",
                            style: PrimaryFont.bodyTextMedium()
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      )
                    : Expanded(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final item = list[index];
                                  return _ItemScheduleHistory(
                                    l10n: l10n,
                                    companyName: item.companyName,
                                    wastype: item.wasteType,
                                    collectionDate: DateFormat('yyyy-MM-dd')
                                        .format(item.collectionDate),
                                    code: item.code,
                                    onTap: () {
                                      Get.toNamed(
                                          AppRoutes.detailScheduleHistory,
                                          arguments: item);
                                    },
                                  );
                                },
                                childCount: list.length,
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemScheduleHistory extends StatelessWidget {
  const _ItemScheduleHistory({
    super.key,
    required this.companyName,
    required this.wastype,
    required this.collectionDate,
    required this.code,
    this.onTap,
    required this.l10n,
  });
  final AppLocalizations l10n;
  final Function()? onTap;
  final String companyName, wastype, collectionDate, code;
  @override
  Widget build(BuildContext context) {
    String image;
    switch (wastype) {
      case 'Chất thải công nghiệp':
        image = "waste_industrial.jpeg";
        break;
      case 'Chất thải sinh hoạt':
        image = "waste_household.jpeg";
        break;
      default:
        image = "waste_hazardous.jpeg";
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      width: 100.w,
      height: 35.w,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: kPrimaryColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.asset(
                  'assets/image/$image',
                  width: 100,
                  height: 80,
                ),
                SizedBox(
                  height: 3.w,
                ),
                Text(
                  code,
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: kPrimaryColor),
                ),
              ],
            ),
          ),
          VerticalDivider(color: kPrimaryColor.withOpacity(0.2)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: PrimaryFont.textCustomBold(3.5.w)
                        .copyWith(color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    wastype,
                    style:
                        PrimaryFont.bodyTextBold().copyWith(color: Colors.red),
                  ),
                  Text(
                    collectionDate,
                    style:
                        PrimaryFont.bodyTextBold().copyWith(color: Colors.grey),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: 15.w,
                        height: 5.w,
                        margin: EdgeInsets.only(top: 3.w, right: 5.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 1),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Text(
                          l10n.txtDetailSH,
                          textAlign: TextAlign.center,
                          style: PrimaryFont.bodyTextMedium()
                              .copyWith(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
