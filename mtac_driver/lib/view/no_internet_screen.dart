import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:mtac_driver/controller/network_check_middleware_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image/no_internet.gif",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                NetworkCheckMiddlewareController.instance
                    .checkConnectionAndRedirect();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Thử lại"),
            ),
          ],
        ),
      ),
    );
  }
}
