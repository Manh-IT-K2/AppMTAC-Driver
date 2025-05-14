import 'package:mtac_driver/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// set username
Future<void> setUsername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
}

// get username
Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? "Unknown";
}

// remove username
Future<void> removeUsername() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
}

// set user model
Future<void> setUserModel(UserModel userModel) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_model', userModelToJson(userModel));
}

// get user model
Future<UserModel?> getUserModel() async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString('user_model');
  if (userJson != null) {
    return userModelFromJson(userJson);
  }
  return null;
}

// remove username
Future<void> removeUserModel() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_model');
}
