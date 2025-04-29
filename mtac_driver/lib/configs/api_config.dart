import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  // initial 
  static const String baseUrl = 'http://partner.moitruongachau.vn';

  //
  Future<bool> checkServerStatus() async {
    final url = Uri.parse(baseUrl); // Uri.parse("$baseUrl/ping")

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (kDebugMode) {
          print("✅ Server is running with port 8000");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("⚠️ Server responded with status: ${response.statusCode}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Không thể kết nối đến server: $e");
      }
      return false;
    }
  }
}
