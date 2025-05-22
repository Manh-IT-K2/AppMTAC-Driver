import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/schedule_widget/statistical_chart_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // initial ScheduleController
  final ScheduleController _scheduleController = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderDriverScreen(
                l10n: l10n,
                scheduleController: _scheduleController,
              ),
              SizedBox(
                height: 3.w,
              ),
              _BodyDriverScreen(
                  l10n: l10n, scheduleController: _scheduleController),
              SizedBox(
                height: 3.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyDriverScreen extends StatelessWidget {
  const _BodyDriverScreen({
    super.key,
    required ScheduleController scheduleController,
    required this.l10n,
  }) : _scheduleController = scheduleController;

  final ScheduleController _scheduleController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    //
    _scheduleController.scrollToToday();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.txtScheduleHighlightD,
          style: PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
        ),
        SizedBox(
          height: 3.w,
        ),
        SizedBox(
          height: 20.w,
          child: ListView.builder(
            controller: _scheduleController.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 9999,
            itemExtent: 13.w, // rất quan trọng để tối ưu!
            itemBuilder: (context, index) {
              return Obx(() {
                // Tính realIndex để lặp lại
                int realIndex = index % _scheduleController.daysInMonth.length;
                DateTime day = _scheduleController.daysInMonth[realIndex];

                // Kiểm tra có phải hôm nay không
                bool isToday = day.day ==
                        _scheduleController.currentDate.value.day &&
                    day.month == _scheduleController.currentDate.value.month &&
                    day.year == _scheduleController.currentDate.value.year;

                // // Danh sách ngày highlight (tùy bạn)
                // List<int> highlightedDays = [
                //   6,
                //   10,
                //   _scheduleController.currentDate.value.day,
                //   22,
                //   26,
                //   29
                // ];
                bool isHighlight =
                    _scheduleController.highlightedDays.contains(day.day);

                return _ItemDayOfWeek(
                  day: day.day.toString(),
                  weekdays: _scheduleController.getWeekdayShortName(day),
                  statusToday: isToday,
                  statusScheduleHighlight: isHighlight,
                );
              });
            },
          ),
        ),
        SizedBox(height: 5.w),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.txtTripColectionTodayD,
                style:
                    PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
              ),
              SizedBox(height: 5.w),
              SizedBox(
                height: 42.w,
                child: CustomScrollView(
                  slivers: [
                    Obx(
                      () => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final datum =
                                _scheduleController.todaySchedules[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.map,
                                      arguments: datum.wasteType);
                                },
                                child: _ItemTripToday(
                                  hour: "8:00",
                                  addressBusiness: datum.locationDetails,
                                ),
                              ),
                            );
                          },
                          childCount: _scheduleController.todaySchedules.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderDriverScreen extends StatelessWidget {
  const _HeaderDriverScreen({
    super.key,
    required this.scheduleController,
    required this.l10n,
  });
  final ScheduleController scheduleController;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text.rich(
                TextSpan(
                  text: l10n.txtHelloD,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.grey, height: 1.5),
                  children: <TextSpan>[
                    TextSpan(
                      text: scheduleController.username.value,
                      style: PrimaryFont.titleTextMedium()
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Center(
                  child: Icon(
                    HugeIcons.strokeRoundedNotification01,
                    size: 6.w,
                    color: kPrimaryColor,
                  ),
                ),
                Positioned(
                  top: 1.w,
                  right: 1.w,
                  child: Container(
                    width: 1.5.w,
                    height: 1.5.w,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Text(
        //   "51C - 7373",
        //   style: PrimaryFont.headerTextBold().copyWith(color: Colors.black),
        // ),
        SizedBox(height: 2.w,),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.w),
          child: Image.asset(
            "assets/image/banner_app.png",
            width: 100.w,
            
            fit: BoxFit.fill,
            
          ),
        ),
        SizedBox(height: 2.w,),
        StatisticalChartWidget(),
        Text(
          l10n.txtUtilDriverD,
          style: PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.schedule);
              },
              child: _UtilDriver(
                color: Colors.purple.withOpacity(0.3),
                icon: HugeIcons.strokeRoundedCalendar03,
                title: l10n.txtTitleScheduleColectionD,
                subTitle: l10n.txtSubTitleScheduleColectionD,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                scheduleController.getListScheduleHistory();
                Get.toNamed(AppRoutes.scheduleHistory);
              },
              child: _UtilDriver(
                color: Colors.orange.withOpacity(0.3),
                icon: HugeIcons.strokeRoundedSmartPhone01,
                title: l10n.txtTitleHistoryD,
                subTitle: l10n.txtSubTitleHistoryD,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.w,
        ),
      ],
    );
  }
}

class _ItemTripToday extends StatelessWidget {
  const _ItemTripToday({
    super.key,
    required this.hour,
    required this.addressBusiness,
  });
  final String hour, addressBusiness;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hour,
          style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          width: 70.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Center(
            child: Text(
              addressBusiness,
              style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemDayOfWeek extends StatelessWidget {
  const _ItemDayOfWeek({
    super.key,
    required this.day,
    required this.weekdays,
    required this.statusToday,
    required this.statusScheduleHighlight,
  });

  final String day, weekdays;
  final bool statusToday, statusScheduleHighlight;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 13.w,
      height: 20.w,
      decoration: BoxDecoration(
        color:
            statusToday ? kPrimaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            day,
            style: PrimaryFont.headerTextBold()
                .copyWith(color: statusToday ? Colors.red : Colors.black),
          ),
          Text(
            weekdays,
            style: PrimaryFont.bodyTextMedium()
                .copyWith(color: statusToday ? Colors.red : Colors.black),
          ),
          statusScheduleHighlight
              ? Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _UtilDriver extends StatelessWidget {
  const _UtilDriver({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subTitle,
  });

  final IconData icon;
  final Color color;
  final String title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      width: 50.w - 24,
      height: 30.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 7.w,
            color: Colors.black,
          ),
          SizedBox(
            height: 2.w,
          ),
          Text(
            title,
            style: PrimaryFont.titleTextBold().copyWith(color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 2.w,
          ),
          Text(
            subTitle,
            style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
