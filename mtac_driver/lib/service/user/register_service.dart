// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:mtac/configs/api_config.dart';

// class RegisterService extends GetxService {
//    // initial url
//   final String baseUrl = ApiConfig.baseUrl;

//   Future<bool> register({
//     required String name,
//     required String email,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     final url = Uri.parse("$baseUrl/api/register");

//     final response = await http.post(
//       url,
//       body: {
//         'name': name,
//         'email': email,
//         'password': password,
//         'password_confirmation': confirmPassword,
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (kDebugMode) {
//         print("Đăng ký success: $data");
//       }
//       return true;
//     } else {
//       if (kDebugMode) {
//         print("Đăng ký thất bại: ${response.body}");
//       }
//       return false;
//     }
//   }

//   // Call API from server with check validate email
//   Future<bool> validateEmail(String email) async {
//     final url = Uri.parse("$baseUrl/api/validate-email");
//     final response = await http.post(url, body: {
//       "email": email
//     });
//     if(response.statusCode == 200){
//       final data = jsonEncode(response.body);
//       if (kDebugMode) {
//         print("Email validate: $data");
//       }
//       return true;
//     }
//     if (kDebugMode) {
//       print("Email not validate");
//     }
//     return false;
//   }

  
//   // Call API from server with check validate password
//   Future<bool> validatePassword(String password) async {
//     final url = Uri.parse("$baseUrl/api/validate-password");
//     final response = await http.post(url, body: {
//       "password": password
//     });
//     if(response.statusCode == 200){
//       final data = jsonEncode(response.body);
//       if (kDebugMode) {
//         print("password validate: $data");
//       }
//       return true;
//     }
//     if (kDebugMode) {
//       print("password not validate");
//     }
//     return false;
//   }
// }
