import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScheduleColectionDriverScreen extends StatelessWidget {
  ScheduleColectionDriverScreen({super.key});

  final ScheduleController _scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    //
    final l10n = AppLocalizations.of(context)!;
    // Get day ToDay
    DateTime now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    String today = "$day - $month - $year";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 5.w,
              ),
            ),
            Text(
              l10n.txtTitleS,
              style: PrimaryFont.headerTextBold().copyWith(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                // _scheduleController.removeCollectionStatus();
                // _scheduleController.removeSchedule();
              },
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ]),
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: l10n.txtHelloS,
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.grey),
                  ),
                  TextSpan(
                    text: _scheduleController.username.value,
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: Colors.black),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.txtScheduleTodayS,
                    style: PrimaryFont.headerTextBold()
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    today,
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 5.h,
              color: const Color(0xFFEBF5FF),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _scheduleController.wasteTypes
                    .map(
                      (title) => _ItemListTrip(title: title),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _scheduleController.pageController,
                onPageChanged: _scheduleController.onPageChanged,
                children: _scheduleController.wasteTypes.map(
                  (title) {
                    //final data = controller.todaySchedules[0];
                    return Obx(() {
                      final scheduleMap =
                          _scheduleController.schedulesByWasteType;

                      if (scheduleMap.isEmpty) {
                        return Center(
                            child: Text(
                          l10n.txtWhenFinishSC,
                          style: PrimaryFont.bodyTextBold()
                              .copyWith(color: Colors.black),
                        ));
                      }

                      final entries = scheduleMap.entries.toList();

                      return CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final wasteType = entries[index].key;
                                final datum = entries[index]
                                    .value
                                    .first; // Lấy địa điểm đầu tiên của loại chất thải đó

                                return _ItemTripWork(
                                  nameWaste:
                                      wasteType, // hoặc datum.companyName nếu bạn muốn
                                  addressBusiness: datum.locationDetails,
                                  day: DateFormat('yyyy-MM-dd')
                                      .format(datum.collectionDate),
                                  status: datum.status,
                                );
                              },
                              childCount: entries.length,
                            ),
                          ),
                        ],
                      );
                    });
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemTripWork extends StatelessWidget {
  const _ItemTripWork({
    super.key,
    // required this.title,
    required this.nameWaste,
    required this.addressBusiness,
    required this.day,
    required this.status,
  });

  final String nameWaste, addressBusiness, day, status;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 100.w,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 30.w,
                  //   height: 10.w,
                  //   decoration: BoxDecoration(
                  //     color: title.contains("Khoán")
                  //         ? const Color(0xFF22C7E4)
                  //         : title.contains("Cân")
                  //             ? Colors.orange
                  //             : kPrimaryColor,
                  //     borderRadius: BorderRadius.circular(5.w),
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       title,
                  //       style: PrimaryFont.bodyTextBold()
                  //           .copyWith(color: Colors.white),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 3.w,
                  // ),
                  Text(
                    nameWaste,
                    style:
                        PrimaryFont.titleTextBold().copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                  Text(
                    addressBusiness,
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                  Text(
                    day,
                    style:
                        PrimaryFont.bodyTextBold().copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.map, arguments: nameWaste);
            },
            child: Container(
              height: double.infinity,
              width: 8.h,
              decoration: BoxDecoration(
                color: status.contains("Đã sắp")
                    ? kPrimaryColor
                    : status.contains("Đang thu gom")
                        ? Colors.green
                        : const Color(0xFF22C7E4),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.w),
                  bottomRight: Radius.circular(5.w),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: const Offset(1, 4),
                  ),
                ],
              ),
              child: Center(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    status,
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemListTrip extends StatelessWidget {
  final String title;
  final ScheduleController controller = Get.find<ScheduleController>();

  _ItemListTrip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.selectWasteType(title),
      child: Obx(() {
        bool isSelected = controller.selectedWasteType.value == title;
        return IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ),
              Container(
                color: isSelected ? Colors.blue : Colors.transparent,
                height: 2,
                width: isSelected ? double.infinity : 0,
                margin: const EdgeInsets.only(top: 5),
              ),
            ],
          ),
        );
      }),
    );
  }
}
