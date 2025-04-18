import 'package:get/get.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/view/main_screen.dart';
import 'package:mtac_driver/view/schedule/handover_record_driver_screen.dart';
import 'package:mtac_driver/view/schedule/map_driver_screen.dart';
import 'package:mtac_driver/view/schedule/schedule_colection_driver_screen.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
    ),
    GetPage(
      name: AppRoutes.handoverRecord,
      page: () => HandoverRecordDriverScreen(),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => ScheduleColectionDriverScreen(),
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapDriverScreen(),
    ),
  ];
}
