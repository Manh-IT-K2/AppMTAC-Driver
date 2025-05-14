import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  // initial url
  final String baseUrl = ApiConfig.baseUrl;

  // call api from server with function login
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/driver/login");
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      try {
        final userModel = UserModel.fromJson(data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('username', data['user']?['name']);
        await prefs.setString(
            'user_model', userModelToJson(userModel));

        return true;
      } catch (e) {
        if (kDebugMode) {
          print('Lỗi parse UserModel: $e');
        }
        return false;
      }
    } else {
      if (kDebugMode) {
        print("Đăng nhập thất bại: ${response.body}");
      }
      return false;
    }
  }

  // function logout
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse("$baseUrl/api/driver/logout");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove('access_token');
      return true;
    }
    return false;
  }

  // Call api from server with function checkLoginStatus
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      return true;
    }
    return false;
  }

}
