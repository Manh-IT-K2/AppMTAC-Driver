import 'dart:convert';
import 'package:get/get.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Set Grouped Schedule To Local
Future<void> setGroupedScheduleToLocal(Map<String, List<Datum>> grouped) async {
  final prefs = await SharedPreferences.getInstance();

  // trannfer Map<String, List<Datum>> => Map<String, dynamic>
  final Map<String, dynamic> groupedJson = grouped.map(
      (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()));

  final jsonString = jsonEncode(groupedJson);

  await prefs.setString('grouped_schedule_today', jsonString);
}

// Get Grouped Schedule From Local
Future<void> getGroupedScheduleFromLocal(
    RxMap<String, List<Datum>> schedulesByWasteType) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('grouped_schedule_today');

  if (jsonString != null) {
    final Map<String, dynamic> decodedMap = jsonDecode(jsonString);

    // tranfer Map<String, List<Datum>>
    final Map<String, List<Datum>> parsedMap = decodedMap.map((key, value) {
      final list = (value as List).map((e) => Datum.fromJson(e)).toList();
      return MapEntry(key, list);
    });

    schedulesByWasteType.addAll(parsedMap);
  } else {
    schedulesByWasteType.clear();
  }
}

// Remove Grouped Schedule From Local
Future<void> removeGroupedScheduleFromLocal(
    ) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('grouped_schedule_today');
  //schedulesByWasteType.clear();
}

// Check data local exist
Future<bool> hasLocalGroupedSchedule() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('grouped_schedule_today');
}

//
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

// Set Collection Statuses To Local
Future<void> setCollectionStatusesToLocal(
    Map<int, Rx<CollectionStatus>> collectionStatus) async {
  final prefs = await SharedPreferences.getInstance();

  // Chuyển sang Map<String, String> để dễ lưu
  final Map<String, String> mapToSave = collectionStatus.map((key, value) =>
      MapEntry(key.toString(), collectionStatusToString(value.value)));

  await prefs.setString('collection_statuses', jsonEncode(mapToSave));
}

// Get Collection Statuses From Local
Future<void> getCollectionStatusesFromLocal(
    Map<int, Rx<CollectionStatus>> collectionStatus) async {
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

// Remove Local Collection Status
Future<void> removeLocalCollectionStatus(
    Map<int, Rx<CollectionStatus>> collectionStatus) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('collection_statuses');
  collectionStatus.clear();
}
