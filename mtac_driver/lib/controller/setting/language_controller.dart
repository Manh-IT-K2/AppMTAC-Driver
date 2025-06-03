import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/shared/language_shared.dart';

class LanguageController extends GetxController {
  // initial variable change language
  bool get isEnglish => currentLocale.value.languageCode == 'en';
  Rx<Locale> currentLocale = const Locale('vi').obs;

  // Function change language
  Future<void> changeLanguage(String langCode) async {
    await setLanguage(langCode);
    currentLocale.value = Locale(langCode);
    Get.updateLocale(currentLocale.value);
  }

  // Function load saved language
  Future<void> loadSavedLanguage() async {
    final langCode = await getLanguage();
    currentLocale.value = Locale(langCode);
    Get.updateLocale(currentLocale.value);
  }
}
