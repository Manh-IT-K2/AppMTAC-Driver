import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/route/app_route.dart';

class NetworkCheckMiddlewareController extends GetMiddleware {
  @override
  Widget Function()? onPageBuildStart(Widget Function()? page) {
    _checkConnection();
    return page;
  }

  void _checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.first == ConnectivityResult.none) {
      Future.delayed(
        Duration.zero,
        () {
          Get.offAllNamed(AppRoutes.noConnection);
        },
      );
    }
  }
}
