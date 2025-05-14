import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // initial url
  final String baseUrl = ApiConfig.baseUrl;

  // get token saved
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Call api get user
  Future<UserModel> getUser() async {
    final url = Uri.parse('$baseUrl/api/user/account');
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
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  // Call api update user   
  Future<void> updateUser(Map<String, dynamic> updateData) async {
  final url = Uri.parse('$baseUrl/api/user/account');
  final token = await getToken();

  try {
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (kDebugMode) {
        print(data);
      }
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error updating user: $e');
  }
}

}
