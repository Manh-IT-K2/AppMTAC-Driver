import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatisticalUiModel {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color colorIcon;

  StatisticalUiModel({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.colorIcon,
  });
}

List<StatisticalUiModel> getStatisticalItems(AppLocalizations l10n) {
  return [
    StatisticalUiModel(
      title: l10n.txtWeightSCW,
      subTitle: "Tổng khối lượng",
      icon: HugeIcons.strokeRoundedWeightScale01,
      colorIcon: Colors.red,
    ),
    StatisticalUiModel(
      title: l10n.txtCollectionPointSCW,
      subTitle: "Tổng số điểm",
      icon: HugeIcons.strokeRoundedCursorPointer02,
      colorIcon: Colors.green,
    ),
    StatisticalUiModel(
      title: "Đúng giờ",
      subTitle: "Tổng số chuyến đúng giờ",
      icon: HugeIcons.strokeRoundedDeliveryTruck02,
      colorIcon: Colors.purple,
    ),
    StatisticalUiModel(
      title: "Tổng chuyến",
      subTitle: "Tổng số điểm thu gom",
      icon: HugeIcons.strokeRoundedArrowAllDirection,
      colorIcon: Colors.pink,
    ),
    StatisticalUiModel(
      title: "Hoàn tất",
      subTitle: "Tổng số chuyến hoàn tất",
      icon: HugeIcons.strokeRoundedShippingTruck01,
      colorIcon: Colors.blue,
    ),
    StatisticalUiModel(
      title: "Ngày làm",
      subTitle: "Tổng số ngày làm việc",
      icon: HugeIcons.strokeRoundedWorkHistory,
      colorIcon: Colors.orange,
    ),
  ];
}
