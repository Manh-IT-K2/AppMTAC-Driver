import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  //Color.fromARGB(255, 234, 232, 232)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  "Thông báo",
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
        child: Column(
          children: [
            SizedBox(
              height: 5.w,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Today",
                    style: PrimaryFont.titleTextBold()
                        .copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    "Mark all as read",
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.w,
            ),
            const _itemNotification(
              time: "Justnow",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: false,
            ),
            const _itemNotification(
              time: "1h",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: true,
            ),
            const _itemNotification(
              time: "5h",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Yesterday",
                    style: PrimaryFont.titleTextBold()
                        .copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    "Mark all as read",
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.w,
            ),
            const _itemNotification(
              time: "20-05",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: false,
            ),
            const _itemNotification(
              time: "20-05",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: true,
            ),
            const _itemNotification(
              time: "20-05",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: false,
            ),
            const _itemNotification(
              time: "20-05",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: false,
            ),
            const _itemNotification(
              time: "20-05",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: true,
            ),
            const _itemNotification(
              time: "20-05",
              title: "Collection scheduled",
              subTitle:
                  "Mark all as read Mark all as read Mark all as read Mark all as read",
              isReaded: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _itemNotification extends StatelessWidget {
  const _itemNotification({
    super.key,
    required this.title,
    required this.subTitle,
    required this.time,
    this.icon,
    required this.isReaded,
  });

  final String title, subTitle, time;
  final IconData? icon;
  final bool isReaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: isReaded ? Colors.white : Colors.grey[100],
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: isReaded ? Colors.white : kPrimaryColor.withOpacity(0.1),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReaded ? Colors.grey[200] : Colors.white),
              child: Icon(
                HugeIcons.strokeRoundedTruck,
                size: 5.w,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PrimaryFont.bodyTextBold()
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    subTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: PrimaryFont.bodyTextMedium()
                        .copyWith(color: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              time,
              style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
