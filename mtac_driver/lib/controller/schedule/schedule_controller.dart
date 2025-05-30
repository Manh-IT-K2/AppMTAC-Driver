import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:mtac_driver/common/notify/show_notify_snackbar.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/shared/language_shared.dart';
import 'package:mtac_driver/shared/token_shared.dart';
import 'package:mtac_driver/shared/user/user_shared.dart';
import 'package:mtac_driver/widgets/schedule_widget/statistical_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:mtac_driver/service/schedule/schedule_service.dart';
import 'package:mtac_driver/shared/schedule/schedule_shared.dart';

enum CollectionStatus { idle, started, ended }

class ScheduleController extends GetxController {
  // Services
  final ScheduleService _scheduleService = ScheduleService();

  // Controllers
  late final ScrollController scrollController;
  final PageController pageController = PageController();

  // Constants
  static const List<String> _weekdays = [
    "Mo",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sa",
    "Su"
  ];
  static const List<String> _wasteTypes = [
    "Tất cả",
    "Nguy hại",
    "Tái chế",
    "Công nghiệp"
  ];
  // static const int _totalItemCount = 9999;
  // static final double _itemWidth = 13.w;

  // Observables
  final isSelectedSatistical = 0.obs;
  final currentDate = DateTime.now().obs;
  final daysInMonth = <DateTime>[].obs;
  final username = ''.obs;
  final selectedWasteType = "Tất cả".obs;
  final schedulesByWasteType = <String, List<Datum>>{}.obs;
  final todaySchedules = <Datum>[].obs;
  final historySchedules = <Datum>[].obs;
  final checkTodaySchedules = <Datum>[].obs;
  final highlightedDays = <int>[].obs;
  final tripTimes = List.generate(
      12, (index) => '${(index * 2).toString().padLeft(2, '0')}:00');
  var currentFilter = 'day'.obs;
  var stats = <CollectionStats>[].obs;
  var summary = StatisticalSummary(0, 0, 0).obs;
  // initial variable change language
  bool get isEnglish => currentLocale.value.languageCode == 'en';
  Rx<Locale> currentLocale = const Locale('vi').obs;
  // infor user
  final Rxn<UserModel> userDriver = Rxn<UserModel>();

  // State
  final collectionStatus = <int, Rx<CollectionStatus>>{};
  final tripStartTimes = <int, DateTime>{};
  late final double _scrollOffset;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    updateData();
  }

  @override
  void onClose() {
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // Initialization
  void _initialize() {
    //_setupScrollController();
    _loadInitialData();
  }

  // void _setupScrollController() {
  //   daysInMonth.value = _generateDaysInMonth(currentDate.value);
  //   _scrollOffset = _calculateScrollOffset();
  //   scrollController = ScrollController(initialScrollOffset: _scrollOffset);
  // }

  Future<void> _loadInitialData() async {
    await Future.wait([
      loadUserModel(),
      loadUsername(),
      _loadTodaySchedules(),
      _loadArrangedSchedules(),
      _checkAndLoadSchedule(),
      _loadCollectionStatuses(),
    ]);
  }

  // Data loading methods
  Future<void> loadUsername() async {
    username.value = await getUsername() ?? "Unknown";
  }

  // load user model
  Future<void> loadUserModel() async {
    final user = await getUserModel();
    if (user != null) {
      userDriver.value = user;
    }
  }

  //
  Future<void> changeLanguage(String langCode) async {
    await setLanguage(langCode);
    currentLocale.value = Locale(langCode);
    Get.updateLocale(currentLocale.value);
  }

  //
  Future<void> loadSavedLanguage() async {
    final langCode = await getLanguage();
    currentLocale.value = Locale(langCode);
    Get.updateLocale(currentLocale.value);
  }

  Future<void> _loadTodaySchedules() async {
    await getGroupedScheduleFromLocal(schedulesByWasteType);
    todaySchedules
        .assignAll(schedulesByWasteType.values.expand((e) => e).toList());
    debugPrint('✅ Today schedules loaded: ${todaySchedules.length}');
  }

  Future<void> _loadArrangedSchedules() async {
    try {
      final schedules = await _scheduleService.getListScheduleArranged();
      highlightedDays.value = _getValidCollectionDays(schedules);
      debugPrint('✅ Arranged schedules loaded: ${schedules.length}');
    } catch (e) {
      _handleApiError(e, 'Không thể tải lịch đã sắp');
    }
  }

  Future<void> _checkAndLoadSchedule() async {
    final hasLocal = await hasLocalGroupedSchedule();
    if (hasLocal) {
      await getGroupedScheduleFromLocal(schedulesByWasteType);
      debugPrint("✅ Loaded local grouped schedule");
    } else {
      debugPrint("🚨 Local schedule not found, calling API");
      await _getListScheduleToday();
    }
  }

  Future<void> _loadCollectionStatuses() async {
    await getCollectionStatusesFromLocal(collectionStatus);
  }

  // API operations
  Future<void> _getListScheduleToday() async {
    try {
      debugPrint(">>> GỌI getListScheduleToday từ Controller");
      final schedule = await _scheduleService.getListScheduleToday();
      schedulesByWasteType.value = schedule;
      debugPrint(
          "Các loại chất thải hôm nay: ${schedulesByWasteType.keys.toList()}");
    } catch (e) {
      _handleApiError(e, 'Không thể tải lịch hôm nay');
    }
  }

  Future<void> getListScheduleHistory() async {
    try {
      final schedule = await _scheduleService.getListScheduleHistory();
      historySchedules.assignAll(schedule);
    } catch (e) {
      _handleApiError(e, 'Không thể tải lịch sử');
    }
  }

  // Collection operations
  Future<void> startCollectionTrip(int scheduleId) async {
    debugPrint('--- DEBUG: Danh sách trạng thái collection ---');
    collectionStatus.forEach((key, value) =>
        debugPrint('🟡 scheduleId: $key, status: ${value.value}'));

    try {
      final success = await _scheduleService.startCollectionTrip(scheduleId);
      if (success) {
        collectionStatus[scheduleId] ??= CollectionStatus.idle.obs;
        collectionStatus[scheduleId]!.value = CollectionStatus.started;
        await setCollectionStatusesToLocal(collectionStatus);
      } else {
        showError('Không thể bắt đầu chuyến thu gom');
      }
    } catch (e) {
      _handleApiError(
          e, 'Đã xảy ra lỗi khi bắt đầu chuyến thu gom. Vui lòng thử lại.');
    }
  }

  Future<void> endCollectionTrip(
    int scheduleId,
    List<Map<String, dynamic>> selectedGoods,
    List<File> selectedImages,
  ) async {
    if (selectedGoods.isEmpty || selectedImages.isEmpty) {
      showError("Chưa ghi biên bản giao nhận");
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
        await setCollectionStatusesToLocal(collectionStatus);
      } else {
        showError("Không thể kết thúc thu gom");
      }
    } catch (e) {
      _handleApiError(e, "Đã có lỗi xảy ra khi kết thúc thu gom");
    }
  }

  // Helper methods
  List<int> _getValidCollectionDays(List<Datum> schedules) {
    final now = DateTime.now();
    final days = schedules
        .where((s) => s.collectionDate.isSameMonthAndYear(now))
        .map((s) => s.collectionDate.day)
        .toSet()
      ..add(now.day);
    return days.toList()..sort();
  }

  // double _calculateScrollOffset() {
  //   final todayIndex =
  //       daysInMonth.indexWhere((day) => day.isSameDate(currentDate.value));
  //   final middleItem = _totalItemCount ~/ 2;
  //   final targetIndex =
  //       middleItem - (middleItem % daysInMonth.length) + todayIndex;
  //   return (targetIndex * _itemWidth) - ((100.w - 32) / 2) + (_itemWidth / 2);
  // }

  List<DateTime> _generateDaysInMonth(DateTime date) {
    final daysCount = DateTime(date.year, date.month + 1, 0).day;
    return List.generate(
        daysCount, (i) => DateTime(date.year, date.month, i + 1));
  }

  void _handleApiError(dynamic error, String defaultMessage) {
    if (error.toString().contains('401')) {
      showError('Token hết hạn hoặc không hợp lệ. Vui lòng đăng nhập lại.');
      Get.toNamed(AppRoutes.splash);
      removeToken();
    } else {
      showError(defaultMessage);
    }
    debugPrint('Error: $error');
  }

  void changeFilter(String filter) {
    currentFilter.value = filter;
    updateData();
  }

  void updateData() {
    if (currentFilter.value == 'day') {
      stats.value = generateHourlyData();
    } else if (currentFilter.value == 'week') {
      stats.value = generateWeeklyData();
    } else {
      stats.value = generateMonthlyData();
    }
    summary.value = generateSummary(stats);
  }

  StatisticalSummary generateSummary(List<CollectionStats> data) {
    final totalKg =
        data.fold(0, (sum, e) => sum + Random().nextInt(100)); // giả lập
    final totalPoints = data.length;
    final totalDays = currentFilter.value == 'day'
        ? 1
        : currentFilter.value == 'week'
            ? 7
            : 30;

    return StatisticalSummary(totalKg, totalPoints, totalDays);
  }

  List<CollectionStats> generateHourlyData() {
    return List.generate(8, (index) {
      final hour = 6 + index * 2;
      return CollectionStats(
          '${hour}h', Random().nextInt(2), Random().nextInt(3), 1);
    });
  }

  List<CollectionStats> generateWeeklyData() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.map((day) {
      final total = Random().nextInt(3) + 1;
      final completed = Random().nextInt(total + 1);
      final onTime = Random().nextInt(completed + 1);
      return CollectionStats(day, onTime, completed, total);
    }).toList();
  }

  List<CollectionStats> generateMonthlyData() {
    return List.generate(12, (i) {
      final total = Random().nextInt(3) + 1;
      final completed = Random().nextInt(total + 1);
      final onTime = Random().nextInt(completed + 1);
      return CollectionStats('T${i + 1}', onTime, completed, total);
    });
  }

  // UI methods
  void scrollToToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          _scrollOffset,
          duration: 500.milliseconds,
          curve: Curves.easeInOut,
        );
        debugPrint('>> Scroll to today offset: $_scrollOffset');
      }
    });
  }

  void selectWasteType(String type) {
    final index = _wasteTypes.indexOf(type);
    if (index != -1) {
      selectedWasteType.value = type;
      pageController.animateToPage(
        index,
        duration: 300.milliseconds,
        curve: Curves.easeInOut,
      );
    }
  }

  void selectedItemStatistical(int index) {
    isSelectedSatistical.value = index;
  }

  void onPageChanged(int index) {
    if (index >= 0 && index < _wasteTypes.length) {
      selectedWasteType.value = _wasteTypes[index];
    }
  }

  // Getters
  String getWeekdayShortName(DateTime date) => _weekdays[date.weekday - 1];
  List<Datum> getSchedulesByWasteType(String wasteType) =>
      schedulesByWasteType[wasteType] ?? [];
  List<String> get wasteTypes => _wasteTypes;
}

// Extensions
extension DateUtils on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
  bool isSameMonthAndYear(DateTime other) =>
      year == other.year && month == other.month;
}
