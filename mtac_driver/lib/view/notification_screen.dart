import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarCommon(hasMenu: false, title: l10n.txtTitleNS),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _itemTitleHeader(
              l10n: l10n,
              title: l10n.txtTodayNS,
              subTitle: l10n.txtAllReadNS,
            ),
            _itemNotification(
              time: l10n.txtJustnowNS,
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
            _itemTitleHeader(
              l10n: l10n,
              title: l10n.txtYesterdayS,
              subTitle: l10n.txtAllReadNS,
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
            SizedBox(
              height: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}

/* title header */
class _itemTitleHeader extends StatelessWidget {
  const _itemTitleHeader({
    super.key,
    required this.l10n,
    required this.title,
    required this.subTitle,
  });

  final AppLocalizations l10n;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.w),
      child: Row(
        children: [
          Text(
            title,
            style: PrimaryFont.titleTextBold().copyWith(color: Colors.black),
          ),
          const Spacer(),
          Text(
            subTitle,
            style: PrimaryFont.bodyTextBold().copyWith(color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}

/* item notification */
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
        // border: Border.symmetric(
        //   horizontal: BorderSide(
        //     width: 1,
        //     color: isReaded ? Colors.white : kPrimaryColor.withOpacity(0.1),
        //   ),
        // ),
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
