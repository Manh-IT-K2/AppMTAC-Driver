import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:mtac_driver/widgets/user_widget/input_form_widget.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nummberIDController = TextEditingController();
  final numberVehicleController = TextEditingController();
  final taxCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor.withOpacity(0.8),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 100.w,
              margin: EdgeInsets.only(left: 16.0, top: 7.h, right: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      HugeIcons.strokeRoundedArrowLeft01,
                      color: Colors.white,
                      size: 8.w,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "My Profile",
                      textAlign: TextAlign.center,
                      style: PrimaryFont.headerTextBold().copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 100.w,
              height: 85.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.w),
                  topRight: Radius.circular(5.w),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, top: 10.w, right: 10.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 90,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.w),
                              child: Image.asset(
                                'assets/image/Logo_MTACmerchant.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      InputFormWidget(
                        controller: nameController,
                        title: "Name",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      InputFormWidget(
                        controller: emailController,
                        title: "Email",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      InputFormWidget(
                        controller: phoneController,
                        title: "Phone number",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      InputFormWidget(
                        controller: nummberIDController,
                        title: "Card ID",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      InputFormWidget(
                        controller: numberVehicleController,
                        title: "Vehicle License",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      InputFormWidget(
                        controller: taxCodeController,
                        title: "Tax Code",
                        obscureText: false,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.w),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
                          "Update profile",
                          style: PrimaryFont.bodyTextMedium().copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
