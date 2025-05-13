import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/service/schedule/schedule_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// extension ListExtensions<T> on List<T> {
//   List<T> takeLast(int n) {
//     return skip(length - n).toList();
//   }
// }

// status collection
enum CollectionStatus { idle, started, ended }

class ScheduleController extends GetxController {
  // initial variable for time
  var currentDate = DateTime.now().obs;
  var daysInMonth = <DateTime>[].obs;
  late final ScrollController scrollController;

  // final Map<int, RxBool> startingStatus = {}; // key: scheduleId
  // bool get isAnyTripStarted {
  //   return startingStatus.values.any((status) => status.value);
  // }

  // Future<void> saveStartingStatusesToLocal() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // Chuyển Map<int, RxBool> thành Map<int, bool>
  //   final Map<String, bool> mapToSave = startingStatus.map((key, value) {
  //     return MapEntry(key.toString(), value.value);
  //   });

  //   // Lưu vào SharedPreferences dưới dạng chuỗi JSON
  //   await prefs.setString('starting_statuses', jsonEncode(mapToSave));
  // }

  // Future<void> loadStartingStatusesFromLocal() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString('starting_statuses');

  //   if (jsonString != null) {
  //     final Map<String, dynamic> decoded = jsonDecode(jsonString);

  //     // Chuyển đổi từ Map<String, bool> thành Map<int, RxBool>
  //     decoded.forEach((key, value) {
  //       final int id = int.parse(key);
  //       startingStatus[id] = (value as bool).obs;
  //     });
  //   }
  // }

  // status collection
  Map<int, Rx<CollectionStatus>> collectionStatus = {};
  String collectionStatusToString(CollectionStatus status) {
    return status.toString().split('.').last;
  }

  //
  CollectionStatus collectionStatusFromString(String value) {
    return CollectionStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => CollectionStatus.idle,
    );
  }

  // saveCollectionStatusesToLocal
  Future<void> saveCollectionStatusesToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    // Chuyển sang Map<String, String> để dễ lưu
    final Map<String, String> mapToSave = collectionStatus.map((key, value) =>
        MapEntry(key.toString(), collectionStatusToString(value.value)));

    await prefs.setString('collection_statuses', jsonEncode(mapToSave));
  }

  // loadCollectionStatusesFromLocal
  Future<void> loadCollectionStatusesFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('collection_statuses');

    if (jsonString != null) {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      decoded.forEach((key, value) {
        final int scheduleId = int.parse(key);
        final CollectionStatus status = collectionStatusFromString(value);

        collectionStatus[scheduleId] = Rx(status);
      });
    }
  }

  // initial tripStartTimes
  final Map<int, DateTime> tripStartTimes = {}; // key: scheduleId

  // initial ScheduleService
  final ScheduleService _scheduleService = ScheduleService();

  // Biến observable để lưu danh sách lịch hôm nay
  RxList<Datum> todaySchedules = <Datum>[].obs;
  RxList<Datum> checkTodaySchedules = <Datum>[].obs;

  // username
  var username = ''.obs;

  // initial variable schedulesByWasteType
  final RxMap<String, List<Datum>> schedulesByWasteType =
      <String, List<Datum>>{}.obs;
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
    //   loadGroupedScheduleFromLocal().then((_) async {
    //   final hasLocal = await hasLocalGroupedSchedule();
    //   if (!hasLocal) {
    //     await getListScheduleToday(); // nếu không có mới gọi API
    //     print("Sai luon getListScheduleToday");
    //   }
    // });
    checkAndLoadSchedule();
    // getListScheduleToday();
    // loadGroupedScheduleFromLocal();
    loadCollectionStatusesFromLocal();
    // loadStartingStatusesFromLocal();

    //loadScheduleFromLocal();
    daysInMonth.value = _generateDaysInMonth(currentDate.value);
    offset = calculateTodayScrollOffset(itemWidth, screenWidth);
    scrollController = ScrollController(initialScrollOffset: offset);
  }

  // Khởi tạo trạng thái
  // void initStartingStatus(List<int> ids) {
  //   for (var id in ids) {
  //     startingStatus[id] = false.obs;
  //   }
  // }

  // calculateTodayScrollOffset
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

  // //
  // Future<void> loadScheduleFromLocal() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString('schedule_today');
  //   if (jsonString != null) {
  //     final List<dynamic> decodedList = jsonDecode(jsonString);
  //     final list = decodedList.map((e) => Datum.fromJson(e)).toList();
  //     todaySchedules.assignAll(list); //
  //     final ids = list.map((e) => e.id).toList();
  //     initStartingStatus(ids);
  //   } else {
  //     todaySchedules.clear(); // Nếu không có data, đảm bảo list rỗng
  //   }
  // }

  Future<bool> hasLocalGroupedSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('grouped_schedule_today');
  }
Future<void> checkAndLoadSchedule() async {
  final hasLocal = await hasLocalGroupedSchedule();
  if (hasLocal) {
    await loadGroupedScheduleFromLocal();
    print("✅ Loaded local grouped schedule");
  } else {
    print("🚨 Local schedule not found, calling API");
    await getListScheduleToday(); // Gọi API và trong đó đã save vào local
  }
}

  // function loadGroupedScheduleFromLocal
  Future<void> loadGroupedScheduleFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('grouped_schedule_today');

    if (jsonString != null) {
      final Map<String, dynamic> decodedMap = jsonDecode(jsonString);

      // Chuyển sang Map<String, List<Datum>>
      final Map<String, List<Datum>> parsedMap = decodedMap.map((key, value) {
        final list = (value as List).map((e) => Datum.fromJson(e)).toList();
        return MapEntry(key, list);
      });

      // Gán vào schedulesByWasteType
      schedulesByWasteType.addAll(parsedMap);
      print("loadGroupedScheduleFromLocal: ${schedulesByWasteType.length}");
      print('✅ jsonString from local: $jsonString');

    } else {
      schedulesByWasteType.clear(); // nếu không có dữ liệu local
    }
  }
  //
  Future<void> clearGroupedScheduleFromLocal() async {
  final prefs = await SharedPreferences.getInstance();

  // Xóa key 'grouped_schedule_today'
  await prefs.remove('grouped_schedule_today');

  // Đồng thời xóa dữ liệu trong biến tạm
  schedulesByWasteType.clear();

  print('Đã xóa dữ liệu grouped_schedule_today khỏi local và bộ nhớ.');
}


  //final RxList<Datum> todaySchedules = <Datum>[].obs;

  // function getSchedulesByWasteType
  List<Datum> getSchedulesByWasteType(String wasteType) {
    final list = schedulesByWasteType[wasteType] ?? [];
    // final ids = list.map((e) => e.id).toList();
    // initStartingStatus(ids);
    return list;
  }

//
  Future<void> getListScheduleToday() async {
    try {
      print(">>> GỌI getListScheduleToday từ Controller");
      final schedule = await _scheduleService.getListScheduleToday();

      schedulesByWasteType.value = schedule;

      // if (kDebugMode) {
      //   print(
      //       "Các loại chất thải hôm nay: ${schedulesByWasteType.keys.toList()}");
      // }
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.snackbar(
            'Lỗi', 'Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar('Lỗi', 'Không thể tải lịch hôm nay',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
      if (kDebugMode) {
        print('ScheduleController Error: $e');
      }
    }
  }

  // start trip collection
  Future<void> startCollectionTrip(int scheduleId) async {
    try {
      // if (isAnyTripStarted && !(startingStatus[scheduleId]?.value ?? false)) {
      //   Get.snackbar(
      //     'Thông báo',
      //     'Bạn cần hoàn thành chuyến thu gom trước đó trước khi bắt đầu chuyến mới.',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.orange,
      //     colorText: Colors.white,
      //   );
      //   return;
      // }

      final success = await _scheduleService.startCollectionTrip(scheduleId);

      if (success) {
        // Đánh dấu chuyến này đang được thu gom
        // startingStatus[scheduleId]?.value = true;
        // saveStartingStatusesToLocal();
        collectionStatus[scheduleId] ??= Rx(CollectionStatus.idle);

        // Cập nhật trạng thái
        collectionStatus[scheduleId]!.value = CollectionStatus.started;
        await saveCollectionStatusesToLocal();

        Get.snackbar(
          'Thành công',
          'Chuyến thu gom đã bắt đầu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (kDebugMode) {
          print("manh ${collectionStatus[scheduleId]?.value}");
        }
      } else {
        Get.snackbar(
          'Thất bại',
          'Không thể bắt đầu chuyến thu gom',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.snackbar(
            'Lỗi', 'Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar(
          'Lỗi',
          'Đã xảy ra lỗi khi bắt đầu chuyến thu gom. Vui lòng thử lại.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      if (kDebugMode) {
        print('startCollectionTrip Error: $e');
      }
    }
  }

  // function endCollectionTrip from service
  Future<void> endCollectionTrip(
      int scheduleId,
      List<Map<String, dynamic>> selectedGoods,
      List<File> selectedImages) async {
    if (selectedGoods.isEmpty || selectedImages.isEmpty) {
      //Get.snackbar("Thiếu thông tin", "Chưa ghi biên bản giao nhận");
      return;
    }

    try {
      final success = await _scheduleService.endCollectionTrip(
        id: scheduleId,
        goods: selectedGoods,
        images: selectedImages,
      );

      if (success) {
        collectionStatus[scheduleId]?.value = CollectionStatus.ended;
        await saveCollectionStatusesToLocal();
        // Get.snackbar("Thành công", "Bắt đầu thu gom thành công");
      } else {
        Get.snackbar("Thất bại", "Không thể bắt đầu thu gom");
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        Get.snackbar(
            'Lỗi', 'Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.',
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar("Lỗi", "Đã có lỗi xảy ra",
            snackPosition: SnackPosition.TOP, colorText: Colors.red);
      }
      if (kDebugMode) print("❌ startCollection error: $e");
    }
  }

  // 🔥memory leak
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
