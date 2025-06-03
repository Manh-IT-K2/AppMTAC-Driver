import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/controller/connection/network_check_middleware_controller.dart';
import 'package:mtac_driver/controller/schedule/handover_record_controller.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/controller/user/help_faqs_controller.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';

class PageBinding extends Bindings {
  @override
  void dependencies(){
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<MapController>(() => MapController());
    Get.lazyPut<HandoverRecordController>(() => HandoverRecordController());
    Get.lazyPut<HelpFAQController>(() => HelpFAQController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<NetworkCheckMiddlewareController>(() => NetworkCheckMiddlewareController());
  }
}