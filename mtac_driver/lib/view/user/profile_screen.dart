import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
import 'package:mtac_driver/widgets/user_widget/input_form_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nummberIDController = TextEditingController();
  final numberVehicleController = TextEditingController();
  final taxCodeController = TextEditingController();
  final addressController = TextEditingController();

  final _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    //
    final l10n = AppLocalizations.of(context)!;
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
                        l10n.txtMyProfileAU,
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
              right: 5.w,
              top: 34.w,
              child: Image.asset(
                'assets/image/icon_change_color.png',
                width: 8.w,
                height: 8.w,
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
                  padding: EdgeInsets.only(left: 16.0, top: 10.w, right: 16.0),
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
                          height: 3.w,
                        ),
                        Text(
                          "Joined on 12/5/2023",
                          style: PrimaryFont.bodyTextMedium().copyWith(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Container(
                          width: 100.w,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Column(
                            children: [
                              InputFormWidget(
                                readOnly: false,
                                controller: nameController,
                                title: l10n.txtNamePU,
                                obscureText: false,
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              InputFormWidget(
                                readOnly: false,
                                controller: phoneController,
                                title: l10n.txtPhone,
                                obscureText: false,
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              InputFormWidget(
                                readOnly: false,
                                controller: emailController,
                                title: l10n.txtEmailPU,
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
                                title: l10n.txtAddressPU,
                                obscureText: false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Container(
                          width: 100.w,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Column(
                            children: [
                              InputFormWidget(
                                readOnly: false,
                                controller: nummberIDController,
                                title: l10n.txtCarIDPU,
                                obscureText: false,
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              InputFormWidget(
                                readOnly: false,
                                controller: numberVehicleController,
                                title: l10n.txtVehicleLicensePU,
                                obscureText: false,
                              ),
                            ],
                          ),
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
                            l10n.txtUpdateProfilePU,
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
