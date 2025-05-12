import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mtac_driver/data/map_screen/item_destination.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:mtac_driver/service/schedule/schedule_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

extension ListExtensions<T> on List<T> {
  List<T> takeLast(int n) {
    return skip(length - n).toList();
  }
}

enum CollectionStatus { idle, started, ended }

class ScheduleController extends GetxController {
  // initial variable for time
  var currentDate = DateTime.now().obs;
  var daysInMonth = <DateTime>[].obs;
  late final ScrollController scrollController;

  final Map<int, RxBool> startingStatus = {}; // key: scheduleId
  bool get isAnyTripStarted {
    return startingStatus.values.any((status) => status.value);
  }

  //
  Map<int, Rx<CollectionStatus>> startingStatuss = {};

  final Map<int, DateTime> tripStartTimes = {}; // key: scheduleId

  final ScheduleService _scheduleService = ScheduleService();

  // Biến observable để lưu danh sách lịch hôm nay
  RxList<Datum> todaySchedules = <Datum>[].obs;
  RxList<Datum> checkTodaySchedules = <Datum>[].obs;

  // username
  var username = ''.obs;

  // initial list weekdays
  final List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

  final int totalItemCount = 9999;
  final double itemWidth = 13.w;
  double screenWidth = 100.w - 32;
  late final double offset;
  // function initial
  @override
  void onInit() {
    super.onInit();
    getUsername();
    getListScheduleToday();
    loadScheduleFromLocal();
    daysInMonth.value = _generateDaysInMonth(currentDate.value);
    offset = calculateTodayScrollOffset(itemWidth, screenWidth);
    scrollController = ScrollController(initialScrollOffset: offset);
  }

  // Khởi tạo trạng thái
  void initStartingStatus(List<int> ids) {
    for (var id in ids) {
      startingStatus[id] = false.obs;
    }
  }

  //
  double calculateTodayScrollOffset(double itemWidth, double screenWidth) {
    int todayIndex = daysInMonth.indexWhere((day) =>
        day.day == currentDate.value.day &&
        day.month == currentDate.value.month &&
        day.year == currentDate.value.year);

    int middle = totalItemCount ~/ 2;
    int targetIndex = middle - (middle % daysInMonth.length) + todayIndex;

    double scrollOffset =
        (targetIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    return scrollOffset;
  }

  // initial list hour away two hour
  List<String> tripTimes = List.generate(12, (index) {
    int hour = index * 2;
    return '${hour.toString().padLeft(2, '0')}:00';
  });

  // initial list day in month
  List<DateTime> _generateDaysInMonth(DateTime date) {
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(
      daysInMonth,
      (index) => DateTime(date.year, date.month, index + 1),
    );
  }

  // initial scroll to Today in center screen
  void scrollToTodayWithContext(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // double offset = calculateTodayScrollOffset(itemWidth, screenWidth);

      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      if (kDebugMode) {
        print('>> Scroll to today offset: $offset');
      }
    });
  }

  // get weekday name
  String getWeekdayShortName(DateTime date) {
    return weekdays[date.weekday - 1];
  }

  // initial variable
  var selectedTitle = "Tất cả".obs;
  var pageController = PageController();

  // list item
  final List<String> items = ["Tất cả", "Nguy hại", "Tái chế", "Công nghiệp"];

  // function chose item
  void selectItem(String title) {
    int index = items.indexOf(title);
    if (index != -1) {
      selectedTitle.value = title;
      if (pageController.hasClients) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // Update status on swipe
  void onPageChanged(int index) {
    if (index >= 0 && index < items.length) {
      selectedTitle.value = items[index];
    }
  }

  // get username
  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'Unknown';
    if (kDebugMode) {
      print("Username loaded: ${username.value}");
    }
  }

//
  Future<void> clearScheduleLocal() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('schedule_today');
}


  //
  Future<void> loadScheduleFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('schedule_today');
    if (jsonString != null) {
      final List<dynamic> decodedList = jsonDecode(jsonString);
      final list = decodedList.map((e) => Datum.fromJson(e)).toList();
      todaySchedules.assignAll(list);//
      final ids = list.map((e) => e.id).toList();
      initStartingStatus(ids);
    } else {
      todaySchedules.clear(); // Nếu không có data, đảm bảo list rỗng
    }
  }

  // Hàm gọi từ UI
//final RxList<Datum> todaySchedules = <Datum>[].obs;
final RxMap<String, List<Datum>> schedulesByWasteType = <String, List<Datum>>{}.obs;

Future<void> getListScheduleToday() async {
  try {
    final schedules = await _scheduleService.getListScheduleToday();
    //todaySchedules.value = schedules;

    // Nhóm theo loại chất thải
    // final Map<String, List<Datum>> grouped = {};
    // for (var schedule in schedules) {
    //   grouped.putIfAbsent(schedule.wasteType, () => []).add(schedule);
    // }
    schedulesByWasteType.value = schedules;

    if (kDebugMode) {
      print("Các loại chất thải hôm nay: ${schedulesByWasteType.keys.toList()}");
    }
  } catch (e) {
    Get.snackbar('Lỗi', 'Không thể tải lịch hôm nay');
    if (kDebugMode) {
      print('ScheduleController Error: $e');
    }
  }
}

  // start trip collection
  Future<void> startCollectionTrip(int scheduleId) async {
    if (isAnyTripStarted && !(startingStatus[scheduleId]?.value ?? false)) {
      Get.snackbar(
        'Thông báo',
        'Bạn cần hoàn thành chuyến thu gom trước đó trước khi bắt đầu chuyến mới.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final success = await _scheduleService.startCollectionTrip(scheduleId);

    if (success) {
      // Đánh dấu chuyến này đang được thu gom
      startingStatus[scheduleId]?.value = true;
      // Khởi tạo nếu chưa có
  startingStatuss[scheduleId] ??= Rx(CollectionStatus.idle);
  
  // Cập nhật trạng thái
  startingStatuss[scheduleId]!.value = CollectionStatus.started;
      Get.snackbar('Thành công', 'Chuyến thu gom đã bắt đầu',
          snackPosition: SnackPosition.BOTTOM);
          print("manh ${startingStatuss[scheduleId]?.value}");
    } else {
      Get.snackbar('Thất bại', 'Không thể bắt đầu chuyến thu gom',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // Danh sách hàng hóa được nhập từ người dùng
//   RxList<Map<String, dynamic>> selectedGoods = <Map<String, dynamic>>[].obs;

// // Danh sách ảnh được chọn từ gallery/camera
//   RxList<File> selectedImages = <File>[].obs;

// Loading indicator
  RxBool isLoading = false.obs;

  Future<void> endCollectionTrip(
      int scheduleId,
      List<Map<String, dynamic>> selectedGoods,
      List<File> selectedImages) async {
    if (selectedGoods.isEmpty || selectedImages.isEmpty) {
      Get.snackbar("Thiếu thông tin", "Chưa ghi biên bản giao nhận");
      return;
    }

    try {
      isLoading.value = true; // nếu bạn dùng loading

      final success = await _scheduleService.endCollectionTrip(
        id: scheduleId,
        goods: selectedGoods,
        images: selectedImages,
      );

      if (success) {
        startingStatuss[scheduleId]?.value = CollectionStatus.ended;

        Get.snackbar("Thành công", "Bắt đầu thu gom thành công");
        // Có thể cập nhật trạng thái schedule tại đây
      } else {
        Get.snackbar("Thất bại", "Không thể bắt đầu thu gom");
      }
    } catch (e) {
      if (kDebugMode) print("❌ startCollection error: $e");
      Get.snackbar("Lỗi", "Đã có lỗi xảy ra");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥memory leak
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
