import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class NotifySuccessDialog {
  void showNotifyPopup(String title, bool status, Function()? onTap) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(top: 10.w),
                    width: 90.w,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: status ? kPrimaryColor : Colors.orange.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(30.w),
                            ),
                            child: status ? Image.asset(
                              "assets/image/icon_congratulation.png",
                              width: 15.w,
                              height: 15.w,
                            ) : Image.asset(
                              "assets/image/icons_warning.png",
                              width: 15.w,
                              height: 15.w,
                            ) ,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          title,
                          style: PrimaryFont.headerTextBold()
                              .copyWith(color: kPrimaryColor),
                        ),
                        SizedBox(height: 10.w),
                        ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: status ? kPrimaryColor : Colors.orange.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              elevation: 5,
                              minimumSize: Size(25.h, 5.h)),
                          child: Text(
                            "OK",
                            style: PrimaryFont.bodyTextBold()
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
