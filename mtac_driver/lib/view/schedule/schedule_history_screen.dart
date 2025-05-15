import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _ItemScheduleHistory(
                      companyName: '',
                      wastype: '',
                      collectionDate: '',
                      plateNumber: ''),
                  _ItemScheduleHistory(
                      companyName: '',
                      wastype: '',
                      collectionDate: '',
                      plateNumber: ''),
                  _ItemScheduleHistory(
                      companyName: '',
                      wastype: '',
                      collectionDate: '',
                      plateNumber: ''),
                  _ItemScheduleHistory(
                      companyName: '',
                      wastype: '',
                      collectionDate: '',
                      plateNumber: ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemScheduleHistory extends StatelessWidget {
  _ItemScheduleHistory({
    super.key,
    required this.companyName,
    required this.wastype,
    required this.collectionDate,
    required this.plateNumber,
  });
  Function()? onTap;
  final String companyName, wastype, collectionDate, plateNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.w),
      width: 100.w,
      height: 30.w,
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
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Image.network(
                  'http://partner.moitruongachau.vn/asset/img/truck-detail.png',
                  width: 100,
                  height: 80,
                ),
                Text(
                  plateNumber,
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: kPrimaryColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  companyName,
                  style:
                      PrimaryFont.titleTextBold().copyWith(color: Colors.black),
                ),
                Text(
                  wastype,
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
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
        ],
      ),
    );
  }
}
