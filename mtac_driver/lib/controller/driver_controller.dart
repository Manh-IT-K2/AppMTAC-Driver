import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DriverController extends GetxController {

  // initial variable for time
  var currentDate = DateTime.now().obs;
  var daysInMonth = <DateTime>[].obs;
  var scrollController = ScrollController();

  // initial list weekdays
  final List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

  // function initial
  @override
  void onInit() {
    super.onInit();
    daysInMonth.value = _generateDaysInMonth(currentDate.value);
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

  // initial scroll to Today in center screen
  void _scrollToToday() {
    int todayIndex = daysInMonth.indexWhere((day) =>
        day.day == currentDate.value.day &&
        day.month == currentDate.value.month &&
        day.year == currentDate.value.year);

    if (todayIndex != -1) {
      double itemWidth = 13.w + 0.6;
      double screenWidth = 100.w;
      double scrollOffset =
          (todayIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      scrollController.animateTo(
        scrollOffset.clamp(0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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

  // 🔥memory leak
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
