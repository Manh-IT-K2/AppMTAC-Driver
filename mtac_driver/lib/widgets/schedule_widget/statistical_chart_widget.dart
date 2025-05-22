import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class CollectionStats {
  final String label; // Nhãn thời gian
  final int onTime; // Lịch gom đúng giờ
  final int completed; // Lịch gom hoàn tất
  final int total; // Tổng chuyến

  CollectionStats(this.label, this.onTime, this.completed, this.total);
}

class StatisticalChartWidget extends StatefulWidget {
  const StatisticalChartWidget({super.key});

  @override
  State<StatisticalChartWidget> createState() => _StatisticalChartWidgetState();
}

class _StatisticalChartWidgetState extends State<StatisticalChartWidget> {
  String currentFilter = 'day'; // 'day', 'week', 'month'
  List<CollectionStats> stats = [];

  @override
  void initState() {
    super.initState();
    updateData();
  }

  void updateData() {
    setState(() {
      if (currentFilter == 'day') {
        stats = generateHourlyData();
      } else if (currentFilter == 'week') {
        stats = generateWeeklyData();
      } else {
        stats = generateMonthlyData();
      }
    });
  }

  List<CollectionStats> generateHourlyData() {
    return List.generate(8, (index) {
      final hour = 6 + index * 2;
      return CollectionStats(
        '${hour}h',
        Random().nextInt(2),
        Random().nextInt(3),
        1,
      );
    });
  }

  List<CollectionStats> generateWeeklyData() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.map((day) {
      final total = Random().nextInt(3) + 1;
      final completed = Random().nextInt(total + 1);
      final onTime = Random().nextInt(completed + 1);
      return CollectionStats(day, onTime, completed, total);
    }).toList();
  }

  List<CollectionStats> generateMonthlyData() {
    return List.generate(12, (i) {
      final total = Random().nextInt(3) + 1;
      final completed = Random().nextInt(total + 1);
      final onTime = Random().nextInt(completed + 1);
      return CollectionStats('T${i + 1}', onTime, completed, total);
    });
  }

  Widget getBottomTitle(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= stats.length) return const SizedBox.shrink();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(stats[index].label, style: const TextStyle(fontSize: 10)),
    );
  }

  List<BarChartGroupData> generateBarGroups() {
    return stats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;
      return BarChartGroupData(
        x: index,
        barsSpace: 2,
        barRods: [
          BarChartRodData(
              toY: stat.onTime.toDouble(), color: const Color(0xFFDADA5E), width: 12),
          BarChartRodData(
              toY: stat.completed.toDouble(), color: const Color(0xFF84E1CA), width: 12),
          BarChartRodData(
              toY: stat.total.toDouble(), color: const Color(0xFFCAABD7), width: 12),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _itemStatistical(
              title: "Ngày",
              isSelected: currentFilter == "day",
              onTap: () {
                setState(() {
                  currentFilter = "day";
                  updateData();
                });
              },
            ),
            _itemStatistical(
              title: "Tuần",
              isSelected: currentFilter == "week",
              onTap: () {
                setState(() {
                  currentFilter = "week";
                  updateData();
                });
              },
            ),
            _itemStatistical(
              title: "Tháng",
              isSelected: currentFilter == "month",
              onTap: () {
                currentFilter = "month";
                updateData();
              },
            ),
          ],
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                maxY: 4,
                barGroups: generateBarGroups(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: getBottomTitle,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: PrimaryFont.bodyTextBold()
                              .copyWith(color: Colors.black),
                        );
                      },
                    ),
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
                          '${rod.toY.toInt()} chuyến',
                          PrimaryFont.bodyTextBold()
                              .copyWith(color: Colors.white));
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendDot(color: Color(0xFFDADA5E), label: "Đúng giờ"),
            SizedBox(width: 10),
            LegendDot(color: Color(0xFF84E1CA), label: "Hoàn tất"),
            SizedBox(width: 10),
            LegendDot(color: Color(0xFFCAABD7), label: "Tổng chuyến"),
          ],
        ),
         SizedBox(
          height: 2.w,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _itemStatisticalByCircle(
              title: "Khối lượng",
              subTitle: "1000 Kg",
            ),
            _itemStatisticalByCircle(
              title: "Điểm thu gom",
              subTitle: "12 Điểm",
            ),
            _itemStatisticalByCircle(
              title: "Ngày làm việc",
              subTitle: "14 Ngày",
            ),
          ],
        ),
      ],
    );
  }
}

class _itemStatistical extends StatelessWidget {
  const _itemStatistical({
    super.key,
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
  final Color color;
  final String label;

  const LegendDot({super.key, required this.color, required this.label});

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
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 30.w,
      margin: EdgeInsets.symmetric(vertical: 5.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFCD5D8),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
          ),
          Container(
            width: 15.w,
            height: 15.w,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Text(
                subTitle,
                textAlign: TextAlign.center,
                style: PrimaryFont.bodyTextBold().copyWith(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
