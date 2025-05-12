import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mtac_driver/configs/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleService {
  // initial url
  final String baseUrl = ApiConfig.baseUrl;

  // get token saved
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Hàm lưu danh sách Datum vào SharedPreferences
Future<void> saveScheduleToLocal(List<Datum> schedules) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(schedules.map((e) => e.toJson()).toList());
  await prefs.setString('schedule_today', jsonString);
}
// Call api getListScheduleToday
  Future<Map<String, List<Datum>>> getListScheduleToday() async {
  final url = Uri.parse('$baseUrl/api/driver/schedules');
  final token = await getToken();

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final scheduleModel = ScheduleModel.fromJson(data);

      // Lấy ngày hôm nay
      // final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      const String today = "2025-05-13";

      // Lọc theo collection_date là hôm nay
      final filtered = scheduleModel.data.where((item) {
        final itemDate = DateFormat('yyyy-MM-dd').format(item.collectionDate);
        return itemDate == today;
      }).toList();

      // Nhóm theo loại chất thải (waste_type)
      Map<String, List<Datum>> grouped = {};
      for (var item in filtered) {
        if (!grouped.containsKey(item.wasteType)) {
          grouped[item.wasteType] = [];
        }
        grouped[item.wasteType]!.add(item);
      }

      // Lưu nếu cần
      // await saveScheduleToLocal(filtered);

      return grouped;
    } else {
      throw Exception(
          'Failed to load data schedule today: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error getting data schedule today: $e');
  }
}


  // Call api startCollectionTrip
  Future<bool> startCollectionTrip(int id) async {
    final url = Uri.parse('$baseUrl/api/driver/schedules/$id/start');
    final token = await getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          debugPrint('✅ Start trip success: ${data['message']}');
          return true;
        } else {
          debugPrint('⚠️ Server responded but failed: ${data['message']}');
          return false;
        }
      } else {
        debugPrint('❌ Failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception occurred: $e');
      return false;
    }
  }

  // Call api endCollectionTrip
  Future<bool> endCollectionTrip({
    required int id,
    required List<Map<String, dynamic>> goods,
    required List<File> images,
  }) async {
    final url = Uri.parse('$baseUrl/api/driver/schedules/$id/complete');
    final token = await getToken();

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Thêm goods vào form-data
      for (int i = 0; i < goods.length; i++) {
        final item = goods[i];
        request.fields['goods[$i][name]'] = item['name'];
        request.fields['goods[$i][quantity]'] = item['quantity'].toString();
      }

      // Thêm images vào form-data
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        final fileStream =
            await http.MultipartFile.fromPath('images[$i]', image.path);
        request.files.add(fileStream);
      }

      // Gửi request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['success'] == true) {
          debugPrint('✅ End trip success: ${data['message']}');
          return true;
        } else {
          debugPrint('⚠️ Server responded but failed: ${data['message']}');
          return false;
        }
      } else {
        debugPrint('❌ Failed with status: ${response.statusCode}');
        debugPrint('Response body: $responseBody');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Exception occurred: $e');
      return false;
    }
  }
}
