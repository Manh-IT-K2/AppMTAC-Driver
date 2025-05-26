import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CollectionStats {
  final String label; // Nhãn thời gian
  final int onTime; // Lịch gom đúng giờ
  final int completed; // Lịch gom hoàn tất
  final int total; // Tổng chuyến

  CollectionStats(this.label, this.onTime, this.completed, this.total);
}

class StatisticalSummary {
  final int totalKg;
  final int totalPoints;
  final int totalDays;

  StatisticalSummary(this.totalKg, this.totalPoints, this.totalDays);
}

class StatisticalChartWidget extends StatelessWidget {
  StatisticalChartWidget({super.key});

  final _scheduleController = Get.find<ScheduleController>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(
      () => Column(
        children: [
          SizedBox(height: 2.w),
          // --- Tabs ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _itemStatistical(
                title: l10n.txtDaySCW,
                isSelected: _scheduleController.currentFilter.value == "day",
                onTap: () => _scheduleController.changeFilter("day"),
              ),
              _itemStatistical(
                title: l10n.txtWeekSCW,
                isSelected: _scheduleController.currentFilter.value == "week",
                onTap: () => _scheduleController.changeFilter("week"),
              ),
              _itemStatistical(
                title: l10n.txtMonthSCW,
                isSelected: _scheduleController.currentFilter.value == "month",
                onTap: () => _scheduleController.changeFilter("month"),
              ),
            ],
          ),

          // --- Bar Chart ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: BarChart(
                BarChartData(
                  maxY: 4,
                  barGroups: generateBarGroups(_scheduleController.stats),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) => getBottomTitle(
                            value, meta, _scheduleController.stats),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} ${l10n.txtTripSCW}',
                          PrimaryFont.bodyTextBold()
                              .copyWith(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: kPrimaryColor.withOpacity(0.3),
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 2.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendDot(color: kSecondaryColor, label: l10n.txtTripOntimeSCW),
              const SizedBox(width: 10),
              LegendDot(color: kPrimaryColor, label: l10n.txtTripFinishSCW),
              const SizedBox(width: 10),
              LegendDot(
                  color: Colors.grey.shade300, label: l10n.txtTripTotalSCW),
            ],
          ),
          SizedBox(
            height: 2.w,
          ),
          Obx(() {
            final summary = _scheduleController.summary.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _itemStatisticalByCircle(
                  title: l10n.txtWeightSCW,
                  icon: HugeIcons.strokeRoundedWeightScale01,
                  colorBegin: const Color(0xFF28B8E4),
                  colorEnd: kPrimaryColor,
                  subTitle: "${summary.totalKg} Kg",
                ),
                _itemStatisticalByCircle(
                  title: l10n.txtCollectionPointSCW,
                  icon: HugeIcons.strokeRoundedCursorPointer02,
                  colorBegin: const Color(0xFF6287E8),
                  colorEnd: const Color(0xFF733FE9),
                  subTitle: "${summary.totalPoints} ${l10n.txtPointSCW}",
                ),
                _itemStatisticalByCircle(
                  title: l10n.txtWorkDaySCW,
                  icon: HugeIcons.strokeRoundedWorkHistory,
                  colorBegin: const Color(0xFFFA815A),
                  colorEnd: const Color(0xFFFB356D),
                  subTitle: "${summary.totalDays} ${l10n.txtDaySCW}",
                ),
              ],
            );
          })
        ],
      ),
    );
  }
}

List<BarChartGroupData> generateBarGroups(List<CollectionStats> stats) {
  return stats.asMap().entries.map((entry) {
    final index = entry.key;
    final stat = entry.value;
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
            toY: stat.onTime.toDouble(), color: kSecondaryColor, width: 12),
        BarChartRodData(
            toY: stat.completed.toDouble(), color: kPrimaryColor, width: 12),
        BarChartRodData(
            toY: stat.total.toDouble(), color: Colors.grey.shade300, width: 12),
      ],
    );
  }).toList();
}

Widget getBottomTitle(
    double value, TitleMeta meta, List<CollectionStats> stats) {
  final index = value.toInt();
  if (index >= stats.length) return const SizedBox.shrink();
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(stats[index].label, style: const TextStyle(fontSize: 10)),
  );
}

class _itemStatistical extends StatelessWidget {
  const _itemStatistical({
    required this.title,
    required this.isSelected,
    this.onTap,
  });
  final String title;
  final bool isSelected;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Center(
          child: Text(
            title,
            style: PrimaryFont.bodyTextMedium()
                .copyWith(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color? color;
  final String label;

  LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
        ),
      ],
    );
  }
}

class _itemStatisticalByCircle extends StatelessWidget {
  const _itemStatisticalByCircle({
    required this.title,
    required this.subTitle,
    required this.colorBegin,
    required this.colorEnd,
    required this.icon,
  });
  final String title, subTitle;
  final Color colorBegin, colorEnd;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 30.w,
      margin: EdgeInsets.symmetric(vertical: 5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [colorBegin, colorEnd]),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: PrimaryFont.bodyTextBold().copyWith(color: Colors.white),
          ),
          Container(
            width: 15.w,
            height: 15.w,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 5.w,
                  color: Colors.black,
                ),
                Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style:
                      PrimaryFont.bold(2.5.w).copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
