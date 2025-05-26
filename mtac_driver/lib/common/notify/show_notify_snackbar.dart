import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showError(String message) {
  Get.snackbar("Lỗi", message,
      snackPosition: SnackPosition.TOP, colorText: Colors.red,   backgroundColor: Colors.red.shade100);
}

void showSuccess(String message) {
  Get.snackbar("Thành công", message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade300,
      colorText: Colors.white);
}
