// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/route/app_page.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:sizer/sizer.dart';

void main() {
  // only portrait
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.white, // Màu thanh trạng thái
  statusBarIconBrightness: Brightness.dark, // Biểu tượng màu tối
));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    // runApp(DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(), // Wrap your app
    // ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Get.config(enableLog: false);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
            // useInheritedMediaQuery: true,
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,

            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                
                scaffoldBackgroundColor: Colors.white),
            initialRoute: AppRoutes.MAIN,
            getPages: AppPages.routes);
      },
    );
  }
}
