import 'package:get/get.dart';
import 'package:mtac_driver/controller/network_check_middleware_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/view/main_screen.dart';
import 'package:mtac_driver/view/connection/connection_middleware_screen.dart';
import 'package:mtac_driver/view/notification_screen.dart';
import 'package:mtac_driver/view/schedule/detail_schedule_history_screen.dart';
import 'package:mtac_driver/view/schedule/handover_record_driver_screen.dart';
import 'package:mtac_driver/view/schedule/map_driver_screen.dart';
import 'package:mtac_driver/view/schedule/schedule_colection_driver_screen.dart';
import 'package:mtac_driver/view/schedule/schedule_history_screen.dart';
import 'package:mtac_driver/view/splash_screen.dart';
import 'package:mtac_driver/view/user/contact_us_screen.dart';
import 'package:mtac_driver/view/user/feedback_screen.dart';
import 'package:mtac_driver/view/user/privacy_policy_screen.dart';
import 'package:mtac_driver/view/user/login_screen.dart';
import 'package:mtac_driver/view/user/profile_screen.dart';
import 'package:mtac_driver/view/user/setting_user/manager_password_screen.dart';
import 'package:mtac_driver/view/user/setting_user/setting_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.noConnection,
      page: () => const ConnectionMiddlewareScreen(),
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
      name: AppRoutes.setting,
      page: () => const SettingScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.managerPassword,
      page: () => ManagerPasswordScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
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
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: () => FeedbackScreen(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
  ];
}
