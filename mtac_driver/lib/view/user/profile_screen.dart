import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
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
  final addressController = TextEditingController();

  final  ProfileController _profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor.withOpacity(0.8),
      body: Obx(() {
        final userModel = _profileController.infoUser.value;
        if (userModel == null) {
          return Center(
            child: Image.asset(
              "assets/image/loadingDot.gif",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          );
        }

        nameController.text = userModel.user.name;
        emailController.text = userModel.user.email;
        phoneController.text = userModel.user.phone;
        nummberIDController.text = userModel.user.soCccd;
        numberVehicleController.text = userModel.user.soGplx;
        taxCodeController.text = userModel.user.masothue ?? 'Chưa đăng ký';
        addressController.text = userModel.user.adress;

        return Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: 100.w,
                margin: EdgeInsets.only(left: 16.0, top: 10.h, right: 16.0),
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
                height: 80.h,
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
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.w),
                                  child: buildAvatar(userModel),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _profileController.pickImageFromGallery();
                                  },
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: false,
                          controller: nameController,
                          title: "Name",
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: false,
                          controller: phoneController,
                          title: "Phone",
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: false,
                          controller: emailController,
                          title: "Email",
                          obscureText: false,
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              HugeIcons.strokeRoundedAlert02,
                              size: 5.w,
                              color: Colors.orange.withOpacity(0.5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: false,
                          controller: addressController,
                          title: "Address",
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: false,
                          controller: nummberIDController,
                          title: "Card ID",
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: true,
                          showCursor: false,
                          controller: taxCodeController,
                          title: "Tax Code",
                          colorText: Colors.grey,
                          obscureText: false,
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              HugeIcons.strokeRoundedAlert02,
                              size: 5.w,
                              color: Colors.orange.withOpacity(0.5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        InputFormWidget(
                          readOnly: false,
                          controller: numberVehicleController,
                          title: "Vehicle License",
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            
                            _profileController.updateUser({
                              "name": nameController.text.trim(),
                              "email": emailController.text.trim(),
                              "masothue": null,
                              "phone": phoneController.text.trim(),
                              "soCCCD": nummberIDController.text.trim(),
                              "adress": addressController.text.trim(),
                              "soGPLX": numberVehicleController.text.trim(),
                            });
                          },
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
                        SizedBox(
                          height: 10.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
