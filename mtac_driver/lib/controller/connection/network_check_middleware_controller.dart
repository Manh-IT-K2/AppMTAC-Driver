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
  RouteSettings? redirect(String? route) {
    // Start async check but return synchronously
    checkConnection();
    return null; // No immediate redirect
  }

  Future<void> checkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final currentRoute = Get.currentRoute;

      if (connectivityResult.isEmpty || 
          connectivityResult.contains(ConnectivityResult.none)) {
        if (currentRoute != AppRoutes.noConnection) {
          Get.offAllNamed(AppRoutes.noConnection);
        }
      } else {
        if (currentRoute == AppRoutes.noConnection) {
          Get.offAllNamed(AppRoutes.splash);
        }
      }
    } catch (e) {
      debugPrint('Network check error: $e');
    }
  }

  @override
  Widget Function()? onPageBuildStart(Widget Function()? page) {
    checkConnection(); // Additional check when page builds
    return page;
  }
}