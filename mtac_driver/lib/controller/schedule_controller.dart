import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

extension ListExtensions<T> on List<T> {
  List<T> takeLast(int n) {
    return skip(length - n).toList();
  }
}

class ScheduleController extends GetxController {
  // initial variable for time
  var currentDate = DateTime.now().obs;
  var daysInMonth = <DateTime>[].obs;
  var scrollController = ScrollController().obs;

  // username
  var username = ''.obs;

  // initial list weekdays
  final List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

  // function initial
  @override
  void onInit() {
    super.onInit();
    getUsername();
    daysInMonth.value = _generateDaysInMonth(currentDate.value);
    //daysInMonth.value = _generateLoopedDaysInMonth(currentDate.value);

    Future.delayed(const Duration(milliseconds: 100), _scrollToToday);
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

  // List<DateTime> _generateLoopedDaysInMonth(DateTime date) {
  //   int daysInMonth = DateTime(date.year, date.month + 1, 0).day;
  //   List<DateTime> originalDays = List.generate(
  //     daysInMonth,
  //     (index) => DateTime(date.year, date.month, index + 1),
  //   );

  //   // Lặp thêm: copy 7 ngày cuối + 7 ngày đầu
  //   List<DateTime> loopedDays = [
  //     ...originalDays.takeLast(7), // 7 ngày cuối lên đầu
  //     ...originalDays,
  //     ...originalDays.take(7), // 7 ngày đầu thêm cuối
  //   ];

  //   return loopedDays;
  // }

  // initial scroll to Today in center screen
 void _scrollToToday() {
  int todayIndex = daysInMonth.indexWhere((day) =>
      day.day == currentDate.value.day &&
      day.month == currentDate.value.month &&
      day.year == currentDate.value.year);

  if (todayIndex != -1) {
    // Vì danh sách 9999, mình đặt today ở giữa:
    int middle = 9999 ~/ 2; // chia lấy nguyên
    int targetIndex = middle - (middle % daysInMonth.length) + todayIndex;

    double itemWidth = 13.w + 1;
    double screenWidth = 100.w;
    double scrollOffset =
        (targetIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    scrollController.value.jumpTo(scrollOffset);
  }
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

  // 🔥memory leak
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
