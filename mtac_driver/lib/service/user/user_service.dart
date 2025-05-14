import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/shared/token_shared.dart';
import 'package:mtac_driver/shared/user/user_shared.dart';

class UserService {
  // initial url
  final String baseUrl = ApiConfig.baseUrl;


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
  Future<UserModel> updateUser(Map<String, dynamic> updateData) async {
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
        await removeUsername();
        await removeUserModel();
        await setUsername(data['data']['user']['name']);
        await setUserModel(UserModel.fromJson(data['data']));
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}
// Future<void> updateUser(
//       Map<String, dynamic> updateData, File? profilePhoto) async {
//     final url = Uri.parse('$baseUrl/api/user/account');
//     final token = await getToken();

//     var request = http.MultipartRequest('PUT', url);
//     request.headers['Authorization'] = 'Bearer $token';
//     request.headers['Accept'] = 'application/json';
//     request.headers ['Content-Type'] = 'application/json';

//     // Thêm các fields
//     updateData.forEach((key, value) {
//       request.fields[key] = value;
//     });

//     // Thêm file ảnh nếu có
//     if (profilePhoto != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//           'profile_photo_path', profilePhoto.path));
//     }

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//        if (kDebugMode) {
//          print(data);
//        }
//       } else {
//         throw Exception('Failed to update user: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating user: $e');
//     }
//   }  