import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/controller/setting/language_controller.dart';
import 'package:mtac_driver/route/app_page.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // only portrait
  WidgetsFlutterBinding.ensureInitialized();
  final _languageController = Get.put(LanguageController());
  await _languageController.loadSavedLanguage();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Get.config(enableLog: false);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _languageController = Get.find<LanguageController>();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          locale: _languageController.currentLocale.value,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('vi'),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
