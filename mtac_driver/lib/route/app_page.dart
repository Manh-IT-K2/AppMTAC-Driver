import 'package:get/get.dart';
import 'package:mtac_driver/controller/network_check_middleware_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/view/main_screen.dart';
import 'package:mtac_driver/view/no_internet_screen.dart';
import 'package:mtac_driver/view/schedule/detail_schedule_history_screen.dart';
import 'package:mtac_driver/view/schedule/handover_record_driver_screen.dart';
import 'package:mtac_driver/view/schedule/map_driver_screen.dart';
import 'package:mtac_driver/view/schedule/schedule_colection_driver_screen.dart';
import 'package:mtac_driver/view/schedule/schedule_history_screen.dart';
import 'package:mtac_driver/view/splash_screen.dart';
import 'package:mtac_driver/view/user/login_screen.dart';
import 'package:mtac_driver/view/user/profile_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.noConnection,
      page: () => const NoInternetScreen(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.handoverRecord,
      page: () => HandoverRecordDriverScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => ScheduleColectionDriverScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapDriverScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.scheduleHistory,
      page: () => ScheduleHistoryScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.detailScheduleHistory,
      page: () => const DetailScheduleHistoryScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
  ];
}
