import 'package:flutter/material.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';
import 'package:mtac_driver/controller/network_check_middleware_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Thử lại",
                style:
                    PrimaryFont.bodyTextMedium().copyWith(color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
