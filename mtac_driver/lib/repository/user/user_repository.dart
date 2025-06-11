import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/shared/token_shared.dart';
import 'package:mtac_driver/shared/user/user_shared.dart';

class UserRepository {
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

  // Call api update password
  Future<UserModel> updatePassword(Map<String, dynamic> updateData) async {
    final url = Uri.parse('$baseUrl/api/driver/password/update');
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
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Call api update avatar
  Future<void> updateAvatar(File avatar) async {
    final url = Uri.parse('$baseUrl/api/driver/avatar');
    final token = await getToken();

    try {
      final request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..files.add(await http.MultipartFile.fromPath(
          'avatar',
          avatar.path,
        ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        if (kDebugMode) {
          print('Upload thành công: $data');
        }
      } else {
        throw Exception(
            'Upload thất bại: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Lỗi khi upload ảnh đại diện: $e');
    }
  }
}
