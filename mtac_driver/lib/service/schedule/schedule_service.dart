import 'dart:convert';

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

  // Call api getListScheduleToday
  Future<List<Datum>> getListScheduleToday() async {
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

        // Parse JSON to model
        final scheduleModel = ScheduleModel.fromJson(data);

        // get today
        //final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        const String today = "2025-04-28";
        // filter list collection_date is today
        final filtered = scheduleModel.data.where((item) {
          final itemDate = DateFormat('yyyy-MM-dd').format(item.collectionDate);
          return itemDate == today;
        }).toList();

        return filtered;
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


}
