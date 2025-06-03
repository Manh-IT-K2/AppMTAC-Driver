import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/service/wheather/wheather_service.dart';
import 'package:mtac_driver/shared/user/user_shared.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';

class Homecontroller extends GetxController {
  // Service
  final _weatherService = WeatherService();

  // Controller
  final ScrollController scrollStatisticalController = ScrollController();

  // Variable obs
  final Rxn<UserModel> userDriver = Rxn<UserModel>();
  var weatherData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final username = ''.obs;

  // init
  @override
  void onInit() {
    super.onInit();
    loadUsername();
    loadUserModel();
    loadWeather();
  }

  // Data loading methods
  Future<void> loadUsername() async {
    username.value = await getUsername() ?? "Unknown";
  }

  Future<void> loadUserModel() async {
    final user = await getUserModel();
    if (user != null) {
      userDriver.value = user;
    }
  }

  Future<void> loadWeather() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final position = await determinePosition();
      final lat = position.latitude;
      final lon = position.longitude;

      final data = await _weatherService.fetchWeather('$lat,$lon');
      weatherData.value = data;
    } catch (e) {
      errorMessage.value = 'Lỗi: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // UI Help Method
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Kiểm tra dịch vụ vị trí có bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Gợi ý bật GPS
      Get.snackbar(
        'GPS đang tắt',
        'Vui lòng bật GPS trong cài đặt để tiếp tục',
        snackPosition: SnackPosition.BOTTOM,
      );
      throw Exception('Dịch vụ định vị chưa được bật');
    }

    // 2. Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();

    // Trường hợp chưa cấp -> xin quyền
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Quyền bị từ chối',
          'Ứng dụng cần quyền vị trí để hoạt động',
          snackPosition: SnackPosition.BOTTOM,
        );
        throw Exception('Không có quyền truy cập vị trí');
      }
    }

    // Trường hợp từ chối vĩnh viễn
    if (permission == LocationPermission.deniedForever) {
      Get.defaultDialog(
        title: 'Quyền vị trí bị từ chối',
        titleStyle: PrimaryFont.titleTextBold().copyWith(color: Colors.black),
        middleText:
            'Vui lòng vào Cài đặt > Quyền ứng dụng để bật lại quyền vị trí cho ứng dụng.',
        middleTextStyle:
            PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
        textConfirm: 'Mở cài đặt',
        buttonColor: kPrimaryColor,
        textCancel: 'Đóng',
        onConfirm: () {
          Geolocator.openLocationSettings();
          Get.back();
        },
      );
      throw Exception('Quyền vị trí bị từ chối vĩnh viễn');
    }
    // OK – có thể lấy vị trí
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
