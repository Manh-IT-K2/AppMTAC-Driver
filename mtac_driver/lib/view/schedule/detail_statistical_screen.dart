import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mtac_driver/widgets/schedule_widget/pie_chart_sample3.dart';
import 'package:sizer/sizer.dart';

class DetailStatisticalScreen extends StatelessWidget {
  const DetailStatisticalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> tripsPerDay = [2, 3, 1, 4, 2, 3, 2];
    final List<String> days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    List<BarChartGroupData> generateBarGroups(List<int> data) {
      return List.generate(data.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data[index].toDouble(),
              color: Colors.red,
              width: 16,
              borderRadius: BorderRadius.circular(10.w),
            )
          ],
        );
      });
    }

    //
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: const AppBarCommon(hasMenu: false, title: "Chi tiết thống kê"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    margin: EdgeInsets.only(right: 3.w),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red.shade100),
                    child: Icon(
                      HugeIcons.strokeRoundedWeightScale01,
                      size: 5.w,
                      color: Colors.red,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tổng khối lượng",
                        textAlign: TextAlign.center,
                        style: PrimaryFont.bodyTextMedium()
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        "803 kg",
                        textAlign: TextAlign.center,
                        style: PrimaryFont.headerTextBold()
                            .copyWith(color: Colors.black, height: 2),
                      ),
                    ],
                  )
                ],
              ),

              // --- Bar Chart ---
              Container(
                width: 100.w,
                margin: EdgeInsets.only(bottom: 5.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 75.w,
                      height: 10.w,
                      margin: EdgeInsets.symmetric(vertical: 5.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.w)),
                      child: Row(
                        children: [
                          Container(
                            width: 25.w,
                            height: 12.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.w),
                              color: kPrimaryColor,
                            ),
                            child: Text(
                              "Ngày",
                              textAlign: TextAlign.center,
                              style: PrimaryFont.bodyTextMedium()
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 25.w,
                            height: 12.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.w),
                              color: Colors.white,
                            ),
                            child: Text(
                              "Tuần",
                              textAlign: TextAlign.center,
                              style: PrimaryFont.bodyTextMedium()
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                          Container(
                            width: 25.w,
                            height: 12.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.w),
                              color: Colors.white,
                            ),
                            child: Text(
                              "Tháng",
                              textAlign: TextAlign.center,
                              style: PrimaryFont.bodyTextMedium()
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: BarChart(
                        BarChartData(
                          maxY: 4,
                          barGroups: generateBarGroups(tripsPerDay),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 && index < days.length) {
                                    return Text(days[index]);
                                  } else {
                                    return const Text('');
                                  }
                                },
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
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
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
                  ],
                ),
              ),
              Text(
                "Tổng hợp theo loại rác",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
              ),
              Container(
                width: 100.w,
                height: 30.h,
                margin: EdgeInsets.symmetric(vertical: 3.w),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PieChartSample3(),
                    SizedBox(
                      width: 10.w,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _itemNoteCircleChart(
                          title: "Chất thải công nghiệp",
                          colorDot: Color(0xFF56E1E9),
                        ),
                        _itemNoteCircleChart(
                            title: "Chất thải sinh hoạt",
                          colorDot: Color(0xFF112C71),
                        ),
                        _itemNoteCircleChart(
                            title: "Chất thải nguy hại",
                          colorDot: Color(0xFF5B58EB),
                        ),
                        _itemNoteCircleChart(
                            title: "Chất thải y tế",
                          colorDot: Color(0xFFBB63FF),
                        ),
                        _itemNoteCircleChart(
                            title: "Chất thải điện tử",
                          colorDot: Color(0xFF0A2353),
                        ),
                        _itemNoteCircleChart(
                            title: "Chất thải gỗ",
                          colorDot: kPrimaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _itemNoteCircleChart extends StatelessWidget {
  const _itemNoteCircleChart({
    super.key,
    required this.title,
    required this.colorDot,
  });
  final String title;
  final Color colorDot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.w),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            margin: EdgeInsets.only(right: 2.w),
            color: colorDot,
          ),
          Text(
            title,
            style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
// List<BarChartGroupData> generateBarGroups(List<CollectionStats> stats) {
//   return stats.asMap().entries.map((entry) {
//     final index = entry.key;
//     final stat = entry.value;
//     return BarChartGroupData(
//       x: index,
//       barRods: [
//         BarChartRodData(
//             toY: stat.onTime.toDouble(), color: kSecondaryColor, width: 12),
//         BarChartRodData(
//             toY: stat.completed.toDouble(), color: kPrimaryColor, width: 12),
//         BarChartRodData(
//             toY: stat.total.toDouble(), color: Colors.grey.shade300, width: 12),
//       ],
//     );
//   }).toList();
// }

// Widget getBottomTitle(
//     double value, TitleMeta meta, List<CollectionStats> stats) {
//   final index = value.toInt();
//   if (index >= stats.length) return const SizedBox.shrink();
//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     child: Text(stats[index].label, style: const TextStyle(fontSize: 10)),
//   );
// }