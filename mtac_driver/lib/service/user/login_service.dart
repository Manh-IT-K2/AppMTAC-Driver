import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mtac_driver/configs/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  // initial url
  final String baseUrl = ApiConfig.baseUrl;

  // call api from server with function login
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/login");
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access_token'];

      if (accessToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        //await prefs.setString('refresh_token', data['refresh_token']);
        //final expiry = DateTime.now().add(Duration(seconds: data['details']?['expires_in']));
       // await prefs.setString('expiry_time', expiry.toIso8601String());
        return true;
      } else {
        if (kDebugMode) {
          print("Không tìm thấy access_token trong response: ${response.body}");
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
  // Future<bool> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('access_token');

  //   final url = Uri.parse("$baseUrl/api/logout");
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json',
  //     },
  //   );

  //   if(response.statusCode == 200){
  //     await prefs.remove('access_token');
  //     return true;
  //   }
  //   return false;
  // }

  // // Call api from server with function checkLoginStatus
  // Future<bool> checkLoginStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final accessToken = prefs.getString('access_token');
  //   final refreshToken = prefs.getString('refresh_token');
  //   final expiryString = prefs.getString('expiry_time');

  //   // check token parameters
  //   if (accessToken == null || refreshToken == null || expiryString == null) {
  //     return false;
  //   }

  //   final expiryTime = DateTime.tryParse(expiryString);
  //   final now = DateTime.now();

  //   // check token is still valid
  //   if (expiryTime != null && now.isBefore(expiryTime)) {
  //     return true;
  //   } else {
  //     final loginService = LoginService();
  //     if (await loginService.refreshTokenWhenExpire()) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  // // call api from server with function login refresh token
  // Future<bool> refreshTokenWhenExpire() async {
  //   final url = Uri.parse("$baseUrl/api/refresh-token");

  //   final prefs = await SharedPreferences.getInstance();
  //   final refreshToken = prefs.getString('refresh_token');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'refresh_token': refreshToken,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final newAccessToken = data['access_token'];
  //       final newRefreshToken = data['refresh_token'];
  //       final expiresIn = data['expires_in'] ?? 3600;

  //       final newExpiry = DateTime.now().add(Duration(seconds: expiresIn));

  //       // Save new token information to SharedPreferences
  //       await prefs.setString('access_token', newAccessToken);
  //       await prefs.setString('refresh_token', newRefreshToken);
  //       await prefs.setString('expiry_time', newExpiry.toIso8601String());
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Lỗi khi refresh token: $e');
  //     }
  //     return false;
  //   }
  // }

  // // function get token
  // Future<String?> getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('access_token');
  // }

  // // call api from server with function getProfile
  // Future<Map<String, dynamic>?> getProfile() async {
  //   final token = await getToken();
  //   if (token == null) return null;

  //   final response = await http.get(
  //     Uri.parse("$baseUrl/api/me"),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     if (kDebugMode) {
  //       print("Lấy thông tin user thất bại: ${response.body}");
  //     }
  //     return null;
  //   }
  // }
}
