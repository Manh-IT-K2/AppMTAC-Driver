import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/schedule_widget/pie_chart_sample3.dart';
import 'package:mtac_driver/widgets/schedule_widget/statistical_chart_widget.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // initial ScheduleController
  final ScheduleController _scheduleController = Get.put(ScheduleController());
  final LoginController loginController = Get.find<LoginController>();
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
                loginController: loginController,
                l10n: l10n,
                scheduleController: _scheduleController,
              ),
              SizedBox(
                height: 5.w,
              ),
              //_BodyDriverScreen(
              //l10n: l10n, scheduleController: _scheduleController),
              Text(
                l10n.txtTripColectionTodayD,
                style:
                    PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 3.w,
              ),
              _itemHightScheduleCollection(
                icon: HugeIcons.strokeRoundedTick01,
                colorBackIcon: Color(0xFF00B7FF).withOpacity(0.6),
                colorStatus: Color(0xFF0099FE),
              ),
              SizedBox(
                height: 3.w,
              ),
              _itemHightScheduleCollection(
                colorStatus: kPrimaryColor,
                colorBackIcon: Color(0xFF0A7BC1),
                icon: HugeIcons.strokeRoundedLoading02,
              ),
              SizedBox(
                height: 3.w,
              ),
              _itemHightScheduleCollection(
                icon: HugeIcons.strokeRoundedTick01,
                colorBackIcon: Color(0xFF00B7FF).withOpacity(0.6),
                colorStatus: Color(0xFF0099FE),
              ),
              SizedBox(
                height: 3.w,
              ),
              _itemHightScheduleCollection(
                colorStatus: kPrimaryColor,
                colorBackIcon: Color(0xFF0A7BC1),
                icon: HugeIcons.strokeRoundedLoading02,
              ),
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

class _itemHightScheduleCollection extends StatelessWidget {
  const _itemHightScheduleCollection({
    super.key,
    required this.icon,
    required this.colorStatus,
    required this.colorBackIcon,
  });
  final IconData icon;
  final Color colorStatus, colorBackIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 20.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w), color: colorStatus),
      child: Row(
        children: [
          Container(
            width: 75.w,
            height: 20.w,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(5.w)),
            child: Row(
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  margin: EdgeInsets.only(left: 3.w, right: 3.w),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(
                    HugeIcons.strokeRoundedTruck,
                    size: 6.w,
                    color: kPrimaryColor,
                  ),
                ),
                //               code": "TG-019",
                // "company_name": "Công ty LG Electronics",
                // "location_details": "KCN Tràng Duệ, Bắc Ninh",
                // "waste_type": "Chất thải điện tử",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "TG-019",
                    //   style: PrimaryFont.bodyTextMedium(),
                    // ),
                    Text(
                      "Công ty LG Electronics",
                      style: PrimaryFont.bold(3.5.w),
                    ),
                    Text(
                      "KCN Tràng Duệ, Bắc Ninh",
                      style: PrimaryFont.bodyTextMedium()
                          .copyWith(color: Colors.grey),
                    ),
                    Text(
                      "Chất thải điện tử",
                      style: PrimaryFont.bodyTextMedium(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 8.w,
            height: 8.w,
            margin: EdgeInsets.only(left: 4.w),
            decoration:
                BoxDecoration(color: colorBackIcon, shape: BoxShape.circle),
            child: Icon(
              icon,
              size: 5.w,
              color: Colors.white,
            ),
          ),
        ],
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         l10n.txtTripColectionTodayD,
        //         style:
        //             PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
        //       ),
        //       SizedBox(height: 5.w),
        //       SizedBox(
        //         height: 42.w,
        //         child: CustomScrollView(
        //           slivers: [
        //             Obx(
        //               () => SliverList(
        //                 delegate: SliverChildBuilderDelegate(
        //                   (context, index) {
        //                     final datum =
        //                         _scheduleController.todaySchedules[index];
        //                     return Padding(
        //                       padding: EdgeInsets.only(bottom: 5.w),
        //                       child: GestureDetector(
        //                         onTap: () {
        //                           Get.toNamed(AppRoutes.map,
        //                               arguments: datum.wasteType);
        //                         },
        //                         child: _ItemTripToday(
        //                           hour: "8:00",
        //                           addressBusiness: datum.locationDetails,
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                   childCount: _scheduleController.todaySchedules.length,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class _HeaderDriverScreen extends StatelessWidget {
  const _HeaderDriverScreen({
    super.key,
    required this.scheduleController,
    required this.l10n,
    required this.loginController,
  });
  final ScheduleController scheduleController;
  final AppLocalizations l10n;
  final LoginController loginController;
  @override
  Widget build(BuildContext context) {
    final user = loginController.infoUser.value;
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
              () => Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(238, 238, 238, 1),
                        width: 1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(child: buildAvatar(user!)),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text.rich(
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
                ],
              ),
            ),
            Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.notification),
                    child: Icon(
                      HugeIcons.strokeRoundedNotification01,
                      size: 6.w,
                      color: kPrimaryColor,
                    ),
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
        // SizedBox(
        //   height: 2.w,
        // ),
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(5.w),
        //   child: Image.asset(
        //     "assets/image/banner_app.png",
        //     width: 100.w,

        //     fit: BoxFit.fill,

        //   ),
        // // ),
        SizedBox(
          height: 3.w,
        ),
        Container(
          width: 100.w,
          height: 45.w,
          margin: EdgeInsets.only(bottom: 5.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.bottomRight,
                colors: [kPrimaryColor.withOpacity(0.4), Colors.white]),
            //color: kPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/image/sun_cloud.png",
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "Mưa phùn",
                    style: PrimaryFont.titleTextBold()
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    "Hôm nay",
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "20˚",
                    style: PrimaryFont.bold(15.w).copyWith(color: Colors.white),
                  ),
                  Text(
                    "Cảm thấy như 25˚",
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.white),
                  ),
                  Image.asset(
                    "assets/image/bg_weather.png",
                    width: 30.w,
                    height: 19.w,
                  ),
                ],
              )
            ],
          ),
          // Row(
          //   children: [
          //     SizedBox(
          //       width: 6.w,
          //     ),
          //     const PieChartSample3(),
          //     const Spacer(),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         SizedBox(
          //           height: 2.w,
          //         ),
          //         const Spacer(),
          //         Row(
          //           children: [
          //             Container(
          //               width: 3.w,
          //               height: 3.w,
          //               color: const Color(0xFF56E1E9),
          //             ),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               "Khối lượng",
          //               style: PrimaryFont.bodyTextMedium()
          //                   .copyWith(color: Colors.black),
          //             )
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Container(
          //               width: 3.w,
          //               height: 3.w,
          //               color: const Color(0xFF112C71),
          //             ),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               "Điểm gom",
          //               style: PrimaryFont.bodyTextMedium()
          //                   .copyWith(color: Colors.black),
          //             )
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Container(
          //               width: 3.w,
          //               height: 3.w,
          //               color: const Color(0xFF5B58EB),
          //             ),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               "Ngày làm",
          //               style: PrimaryFont.bodyTextMedium()
          //                   .copyWith(color: Colors.black),
          //             )
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Container(
          //               width: 3.w,
          //               height: 3.w,
          //               color: const Color(0xFFBB63FF),
          //             ),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               "Tổng chuyến",
          //               style: PrimaryFont.bodyTextMedium()
          //                   .copyWith(color: Colors.black),
          //             )
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Container(
          //               width: 3.w,
          //               height: 3.w,
          //               color: const Color(0xFF0A2353),
          //             ),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               "Hoàn tất",
          //               style: PrimaryFont.bodyTextMedium()
          //                   .copyWith(color: Colors.black),
          //             )
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Container(width: 3.w, height: 3.w, color: kPrimaryColor),
          //             SizedBox(
          //               width: 2.w,
          //             ),
          //             Text(
          //               "Đúng giờ",
          //               style: PrimaryFont.bodyTextMedium()
          //                   .copyWith(color: Colors.black),
          //             )
          //           ],
          //         ),
          //         SizedBox(
          //           height: 3.w,
          //         ),
          //       ],
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         children: [
          //           Align(
          //             alignment: Alignment.topRight,
          //             child: Icon(
          //               HugeIcons.strokeRoundedFilter,
          //               size: 5.w,
          //               color: Colors.black,
          //             ),
          //           ),
          //           Container(
          //             width: 12.w,
          //             height: 20.w,
          //             margin: EdgeInsets.only(top: 1.w),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(2.w),
          //               boxShadow: const [
          //                 BoxShadow(
          //                   blurRadius: 4,
          //                   offset: Offset(0, 3),
          //                   color: Colors.black
          //                 )
          //               ]
          //             ),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   "Ngày",
          //                   style: PrimaryFont.bodyTextMedium()
          //                       .copyWith(color: Colors.black),
          //                 ),
          //                 Text(
          //                   "Tuần",
          //                   style: PrimaryFont.bodyTextMedium()
          //                       .copyWith(color: Colors.black),
          //                 ),
          //                 Text(
          //                   "Tháng",
          //                   style: PrimaryFont.bodyTextMedium()
          //                       .copyWith(color: Colors.black),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
         Text(
          "Phân tích hoạt động",
          style: PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
        ),
        SizedBox(height: 3.w,),
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
                color: Color(0xFF79F3FF),
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
                color: Color(0xFF529DFF),
                icon: HugeIcons.strokeRoundedSmartPhone01,
                title: l10n.txtTitleHistoryD,
                subTitle: l10n.txtSubTitleHistoryD,
              ),
            )
          ],
        ),
        // SizedBox(
        //   height: 5.w,
        // ),
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
