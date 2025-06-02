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
  final _scheduleController = Get.put(ScheduleController());
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
              const _itemHightScheduleCollection(
                icon: HugeIcons.strokeRoundedTick04,
                colorStatus: Colors.green,
              ),
              SizedBox(
                height: 3.w,
              ),
              const _itemHightScheduleCollection(
                colorStatus: Colors.orange,
                icon: HugeIcons.strokeRoundedLoading02,
              ),
              SizedBox(
                height: 3.w,
              ),
              const _itemHightScheduleCollection(
                icon: HugeIcons.strokeRoundedTick04,
                colorStatus: Colors.green,
              ),
              SizedBox(
                height: 3.w,
              ),
              const _itemHightScheduleCollection(
                colorStatus: Colors.orange,
                icon: HugeIcons.strokeRoundedLoading02,
              ),
              SizedBox(
                height: 3.w,
              ),
              SizedBox(
                height: 3.w,
              ),
              const _itemHightScheduleCollection(
                colorStatus: Colors.red,
                icon: HugeIcons.strokeRoundedCancel02,
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
  });
  final IconData icon;
  final Color colorStatus;
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
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(
                    HugeIcons.strokeRoundedTruck,
                    size: 6.w,
                    color: kPrimaryColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Công ty LG Electronics",
                      style: PrimaryFont.textCustomBold(3.5.w),
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
          Expanded(
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
    required this.l10n,
    required this.scheduleController,
  });
  final ScheduleController scheduleController;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
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
            Obx(() {
              final user = scheduleController.userDriver.value;
              return Row(
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
                    child: user == null
                        ? const SizedBox()
                        : ClipOval(
                            child: buildAvatar(user),
                          ),
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
              );
            }),
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
        Obx(() {
          if (scheduleController.isLoading.value) {
            return Center(
              child: Image.asset(
                "assets/image/loadingDot.gif",
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            );
          }

          if (scheduleController.errorMessage.isNotEmpty) {
            return Text(scheduleController.errorMessage.value);
          }

          final weather = scheduleController.weatherData.value;
          if (weather == null) return const SizedBox();

          final temp = weather['current']['temp_c'];
          final feelLike = weather['current']['feelslike_c'];
          final status = weather['current']['condition']['text'];
          //final iconUrl = "https:${weather['current']['condition']['icon']}";
          //final city = weather['location']['name'];

          return Container(
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
                      "assets/image/animation_rain_storm.gif",
                      width: 30.w,
                      height: 28.w,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      status,
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
                      "$temp˚",
                      style: PrimaryFont.textCustomBold(12.w)
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      "Cảm thấy như $feelLike˚",
                      style: PrimaryFont.bodyTextMedium()
                          .copyWith(color: Colors.white),
                    ),
                    Image.asset(
                      "assets/image/bg_weather.png",
                      width: 30.w,
                      height: 19.w,
                    ),
                    // Text(
                    //   "$city",
                    //   style: PrimaryFont.bodyTextMedium()
                    //       .copyWith(color: Colors.black),
                    // ),
                  ],
                ),
              ],
            ),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tổng quan",
              style:
                  PrimaryFont.titleTextMedium().copyWith(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                scheduleController.scrollStatisticalController.animateTo(
                    scheduleController.scrollStatisticalController.offset +
                        50.w,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
              child: Icon(HugeIcons.strokeRoundedArrowRightDouble,
                  size: 5.w, color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 3.w,
        ),
        SingleChildScrollView(
          controller: scheduleController.scrollStatisticalController,
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
                color: const Color(0xFF8DD8FF),
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
                color: const Color(0xFFBBFBFF),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50.w - 24,
        height: 30.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style:
                      PrimaryFont.titleTextBold().copyWith(color: Colors.black),
                ),
                Icon(
                  HugeIcons.strokeRoundedArrowRight02,
                  size: 5.w,
                  color: kPrimaryColor,
                ),
              ],
            ),
            Text(
              subTitle,
              style: PrimaryFont.bodyTextMedium()
                  .copyWith(color: Colors.grey, height: 2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 7.w,
                  color: colorIcon,
                ),
                Text(
                  "705 kg",
                  style:
                      PrimaryFont.titleTextBold().copyWith(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
