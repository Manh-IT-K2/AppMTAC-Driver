import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';

class PieChartSample3 extends StatefulWidget {
  const PieChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30.w,
      height: 30.w,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 5.w : 4.w;
      final iconSize = isTouched ? 5.w : 4.w;
      final radius = isTouched ? 20.w : 18.w;
      final widgetSize = isTouched ? 10.w : 8.w;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFF56E1E9),
            value: 20,
            title: '50%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              iconColor: const Color(0xFF56E1E9),
              icon: HugeIcons.strokeRoundedWeightScale01,
              size: widgetSize,
              iconSize: iconSize,
              borderColor: Colors.black.withOpacity(0.5),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFF112C71),
            value: 10,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              iconColor: const Color(0xFF112C71),
              icon: HugeIcons.strokeRoundedCursorPointer02,
              size: widgetSize,
              iconSize: iconSize,
              borderColor: Colors.black.withOpacity(0.5),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xFF5B58EB),
            value: 16,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              iconColor: const Color(0xFF5B58EB),
              icon: HugeIcons.strokeRoundedWorkHistory,
              size: widgetSize,
              iconSize: iconSize,
              borderColor: Colors.black.withOpacity(0.5),
            ),
            badgePositionPercentageOffset: .98,
          );
        // case 3:
        //   return PieChartSectionData(
        //     color: const Color(0xFFBB63FF),
        //     value: 35,
        //     title: '35%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: const Color(0xffffffff),
        //       shadows: shadows,
        //     ),
        //     badgeWidget: _Badge(
        //       iconColor: const Color(0xFFBB63FF),
        //       icon: HugeIcons.strokeRoundedArrowAllDirection,
        //       size: widgetSize,
        //       borderColor: Colors.black.withOpacity(0.5),
        //     ),
        //     badgePositionPercentageOffset: .98,
        //   );
        // case 4:
        //   return PieChartSectionData(
        //     color: const Color(0xFF0A2353),
        //     value: 23,
        //     title: '23%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: const Color(0xffffffff),
        //       shadows: shadows,
        //     ),
        //     badgeWidget: _Badge(
        //       iconColor: const Color(0xFF0A2353),
        //       icon: HugeIcons.strokeRoundedShippingTruck01,
        //       size: widgetSize,
        //       borderColor: Colors.black.withOpacity(0.5),
        //     ),
        //     badgePositionPercentageOffset: .98,
        //   );
        // case 5:
        //   return PieChartSectionData(
        //     color: kPrimaryColor,
        //     value: 7,
        //     title: '7%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: const Color(0xffffffff),
        //       shadows: shadows,
        //     ),
        //     badgeWidget: _Badge(
        //       iconColor: kPrimaryColor,
        //       icon: HugeIcons.strokeRoundedDeliveryTruck02,
        //       size: widgetSize,
        //       borderColor: Colors.black.withOpacity(0.5),
        //     ),
        //     badgePositionPercentageOffset: .98,
        //   );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.size,
    required this.borderColor,
    required this.iconSize,
    required this.icon, required this.iconColor,
  });
  final IconData icon;
  final double size, iconSize;
  final Color borderColor, iconColor;


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black,
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
