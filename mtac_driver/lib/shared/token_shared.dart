import 'package:shared_preferences/shared_preferences.dart';

// set token
Future<void> setToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

// get token
Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token') ?? "unknown";
}

// remove token
Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('access_token');
}
