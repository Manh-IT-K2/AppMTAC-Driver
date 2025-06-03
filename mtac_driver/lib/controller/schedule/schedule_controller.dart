import 'dart:io';
import 'package:get/get.dart';
import 'package:mtac_driver/common/notify/show_notify_snackbar.dart';
import 'package:mtac_driver/shared/token_shared.dart';
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
  final PageController pageController = PageController();

  // Constants
  static const List<String> _wasteTypes = [
    "Tất cả",
    "Nguy hại",
    "Tái chế",
    "Công nghiệp"
  ];

  // Observables
  final selectedWasteType = "Tất cả".obs;
  final schedulesByWasteType = <String, List<Datum>>{}.obs;
  final todaySchedules = <Datum>[].obs;
  final historySchedules = <Datum>[].obs;
  final isSelectedFilScheduleHistory = 0.obs;
  final isDayScheduleHistory = DateTime.now().obs;
  final isLoadingScheduleHistory = false.obs;

  // State
  final collectionStatus = <int, Rx<CollectionStatus>>{};
  final tripStartTimes = <int, DateTime>{};

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Initialization
  void _initialize() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadTodaySchedules(),
      _checkAndLoadSchedule(),
      _loadCollectionStatuses(),
    ]);
  }

  // Data loading methods

  Future<void> _loadTodaySchedules() async {
    await getGroupedScheduleFromLocal(schedulesByWasteType);
    todaySchedules
        .assignAll(schedulesByWasteType.values.expand((e) => e).toList());
    debugPrint('✅ Today schedules loaded: ${todaySchedules.length}');
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

  Future<void> getListScheduleHistory({DateTime? filterDate}) async {
    try {
      isLoadingScheduleHistory.value = true;
      await Future.delayed(const Duration(milliseconds: 1000));
      final schedule = await _scheduleService.getListScheduleHistory(filterDate: filterDate);
      historySchedules.assignAll(schedule);
      isLoadingScheduleHistory.value = false;
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

  // UI methods
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

  void selectFilterScheduleHistory(int index){
    isSelectedFilScheduleHistory.value = index;
  }

  void onPageChanged(int index) {
    if (index >= 0 && index < _wasteTypes.length) {
      selectedWasteType.value = _wasteTypes[index];
    }
  }

  // Getters
  List<Datum> getSchedulesByWasteType(String wasteType) =>
      schedulesByWasteType[wasteType] ?? [];
  List<String> get wasteTypes => _wasteTypes;
}
