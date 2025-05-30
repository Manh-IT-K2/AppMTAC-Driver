import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/model/ui_model/statistical_ui_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // initial ScheduleController
  final ScheduleController _scheduleController = Get.find<ScheduleController>();
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
                height: 5.w,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.w),
                child: Image.asset("assets/image/banner_app.png"),
              ),
              SizedBox(
                height: 5.w,
              ),
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
                colorBackIcon: const Color(0xFF00B7FF).withOpacity(0.6),
                colorStatus: const Color(0xFF0099FE),
              ),
              SizedBox(
                height: 3.w,
              ),
              const _itemHightScheduleCollection(
                colorStatus: kPrimaryColor,
                colorBackIcon: Color(0xFF0A7BC1),
                icon: HugeIcons.strokeRoundedLoading02,
              ),
              SizedBox(
                height: 3.w,
              ),
              _itemHightScheduleCollection(
                icon: HugeIcons.strokeRoundedTick01,
                colorBackIcon: const Color(0xFF00B7FF).withOpacity(0.6),
                colorStatus: const Color(0xFF0099FE),
              ),
              SizedBox(
                height: 3.w,
              ),
              const _itemHightScheduleCollection(
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
    final user = scheduleController.userDriver.value;
    final items = getStatisticalItems(l10n);
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
        SizedBox(
          height: 3.w,
        ),
        Container(
          width: 100.w,
          height: 42.w,
          margin: EdgeInsets.only(bottom: 5.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [kPrimaryColor.withOpacity(0.4), Colors.white],
            ),
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
                    style: PrimaryFont.bold(12.w).copyWith(color: Colors.white),
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
              ),
            ],
          ),
        ),
        Text(
          "Tổng quan",
          style: PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
        ),
        SizedBox(
          height: 3.w,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              items.length,
              (index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: _itemStatisticalByCircle(
                    onTap: () => Get.toNamed(AppRoutes.detailStatistical),
                    title: item.title,
                    subTitle: item.subTitle,
                    icon: item.icon,
                    colorIcon: item.colorIcon,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
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
                color: const Color(0xFF79F3FF),
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
                color: const Color(0xFF529DFF),
                icon: HugeIcons.strokeRoundedSmartPhone01,
                title: l10n.txtTitleHistoryD,
                subTitle: l10n.txtSubTitleHistoryD,
              ),
            ),
          ],
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

class _itemStatisticalByCircle extends StatelessWidget {
  const _itemStatisticalByCircle({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.colorIcon,
    this.onTap,
  });
  final String title, subTitle;
  final Color colorIcon;
  final IconData icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w - 24,
      height: 30.w,
      padding: EdgeInsets.only(bottom: 1.w),
      decoration: BoxDecoration(
        border: const Border.symmetric(
            horizontal: BorderSide(width: 1, color: kPrimaryColor)),
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100.w,
            height: 20.w,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border.symmetric(
                  vertical: BorderSide(width: 1, color: Colors.grey)),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: PrimaryFont.titleTextBold()
                          .copyWith(color: Colors.black),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onTap,
                      child: Icon(
                        HugeIcons.strokeRoundedArrowRight02,
                        size: 5.w,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  subTitle,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.grey, height: 2),
                ),
              ],
            ),
          ),
          Center(
            child: Icon(
              icon,
              size: 7.w,
              color: colorIcon,
            ),
          ),
        ],
      ),
    );
  }
}
