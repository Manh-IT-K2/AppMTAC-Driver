import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class ScheduleHistoryScreen extends StatelessWidget {
  ScheduleHistoryScreen({super.key});
  final _scheduleController = Get.find<ScheduleController>();
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
                child:
                    Icon(Icons.arrow_back_ios, color: Colors.black, size: 5.w),
              ),
              Expanded(
                child: Text(
                  "Lịch sử thu gom",
                  textAlign: TextAlign.center,
                  style: PrimaryFont.headerTextBold()
                      .copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () {
          final list = _scheduleController.historySchedules;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = list[index];
                      return _ItemScheduleHistory(
                        companyName: item.companyName,
                        wastype: item.wasteType,
                        collectionDate: DateFormat('yyyy-MM-dd')
                            .format(item.collectionDate),
                        code: item.code,
                      );
                    },
                    childCount: list.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class _ItemScheduleHistory extends StatelessWidget {
  _ItemScheduleHistory({
    super.key,
    required this.companyName,
    required this.wastype,
    required this.collectionDate,
    required this.code,
  });
  Function()? onTap;
  final String companyName, wastype, collectionDate, code;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      width: 100.w,
      height: 35.w,
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.asset(
                  'assets/image/icon_package.png',
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style:
                        PrimaryFont.bold(3.5.w).copyWith(color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  //  Text(
                  //   area,
                  //   style:
                  //       PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
                  // ),
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
                          "Chi tiết",
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
