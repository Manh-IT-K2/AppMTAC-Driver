import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/route/app_route.dart';

class NetworkCheckMiddlewareController extends GetMiddleware {
  static final NetworkCheckMiddlewareController instance =
      NetworkCheckMiddlewareController._internal();

  NetworkCheckMiddlewareController._internal();

  factory NetworkCheckMiddlewareController() => instance;

  @override
  Widget Function()? onPageBuildStart(Widget Function()? page) {
    checkConnectionAndRedirect();
    return page;
  }

  Future<void> checkConnectionAndRedirect() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.first == ConnectivityResult.none) {
      if (Get.currentRoute != AppRoutes.noConnection) {
        Get.offAllNamed(AppRoutes.noConnection);
      }
    } else {
      // Nếu đang ở màn mất kết nối mà đã có mạng thì quay về splash
      if (Get.currentRoute == AppRoutes.noConnection) {
        Get.offAllNamed(AppRoutes.splash);
      }
    }
  }
}
