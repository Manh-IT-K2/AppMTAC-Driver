import 'package:get/get.dart';
import 'package:mtac_driver/binding/page_binding.dart';
import 'package:mtac_driver/controller/connection/network_check_middleware_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/view/main_screen.dart';
import 'package:mtac_driver/view/connection/connection_middleware_screen.dart';
import 'package:mtac_driver/view/notification_screen.dart';
import 'package:mtac_driver/view/schedule/detail_schedule_history_screen.dart';
import 'package:mtac_driver/view/schedule/detail_statistical_screen.dart';
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
import 'package:mtac_driver/view/user/setting_location/setting_location_screen.dart';
import 'package:mtac_driver/view/user/setting_notify/setting_notification_screen.dart';
import 'package:mtac_driver/view/user/setting_user/manager_password_screen.dart';
import 'package:mtac_driver/view/user/setting_user/setting_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.noConnection,
      binding: PageBinding(),
      page: () => const ConnectionMiddlewareScreen(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.handoverRecord,
      page: () => HandoverRecordDriverScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => ScheduleColectionDriverScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapDriverScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => const SettingScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.managerPassword,
      page: () => ManagerPasswordScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.scheduleHistory,
      page: () => ScheduleHistoryScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.detailScheduleHistory,
      page: () => const DetailScheduleHistoryScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => const NotificationScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: () => FeedbackScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.detailStatistical,
      page: () => const DetailStatisticalScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.settingNotify,
      page: () => const SettingNotificationScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
    GetPage(
      name: AppRoutes.settingLocation,
      page: () => const SettingLocationScreen(),
      binding: PageBinding(),
      middlewares: [NetworkCheckMiddlewareController()],
    ),
  ];
}
