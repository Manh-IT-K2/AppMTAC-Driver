import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mtac_driver/model/user_model.dart';

Widget buildAvatar(UserModel userModel) {
  String? photoUrl = userModel.user.profilePhotoUrl;
  String? photoPath = userModel.user.profilePhotoPath;
  Widget defaultAvatar = Image.asset(
    'assets/image/default_avatar.jpg',
    fit: BoxFit.cover,
  );

  if (photoPath != '' && photoPath != null && File(photoPath).existsSync()) {
    return Image.file(
      File(photoUrl),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => defaultAvatar,
    );
  }

  if (photoUrl.isNotEmpty) {
    //final fullUrl = 'http://localhost:8000/storage/$photoPath';
    return Image.network(
      photoUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => defaultAvatar,
    );
  }

  return defaultAvatar;
}
