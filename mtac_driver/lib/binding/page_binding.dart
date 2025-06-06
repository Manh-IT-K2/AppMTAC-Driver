import 'package:get/get.dart';
import 'package:mtac_driver/controller/connection/network_check_middleware_controller.dart';
import 'package:mtac_driver/controller/home_controller.dart';
import 'package:mtac_driver/controller/schedule/handover_record_controller.dart';
import 'package:mtac_driver/controller/schedule/map_controller.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/controller/setting/language_controller.dart';
import 'package:mtac_driver/controller/user/help_faqs_controller.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';

class PageBinding extends Bindings {
  @override
  void dependencies(){
    Get.lazyPut<Homecontroller>(() => Homecontroller());
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<MapDriverController>(() => MapDriverController());
    Get.lazyPut<HandoverRecordController>(() => HandoverRecordController());
    Get.lazyPut<HelpFAQController>(() => HelpFAQController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<LanguageController>(() => LanguageController());
    Get.lazyPut<NetworkCheckMiddlewareController>(() => NetworkCheckMiddlewareController());
  }
}