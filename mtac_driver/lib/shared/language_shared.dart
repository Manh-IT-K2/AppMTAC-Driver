import 'package:shared_preferences/shared_preferences.dart';


// set language
Future<void> setLanguage(String langCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language_code', langCode);
}

// get language
Future<String> getLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('language_code') ?? 'vi';
}

