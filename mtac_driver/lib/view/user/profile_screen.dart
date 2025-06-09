import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/common/button/button_long.dart';
import 'package:mtac_driver/configs/api_config.dart';
import 'package:mtac_driver/controller/user/profile_controller.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/user_widget/build_avatar_widget.dart';
import 'package:mtac_driver/common/input/input_form.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    // initial AppLocalizations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kPrimaryColor.withOpacity(0.8),
      body: Obx(
        () {
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

          Image imageWidget;
          if (_profileController.imgPath.value.isEmpty) {
            imageWidget = Image.network(
              "${ApiConfig.urlImage}${userModel.user.imgGplxPath}",
              height: 20.h,
            );
          } else {
            imageWidget = Image.file(File(_profileController.imgPath.value),
                height: 20.h, fit: BoxFit.cover,);
          }

          if (_profileController.nameController.text.isEmpty) {
            _profileController.nameController.text = userModel.user.name;
            _profileController.emailController.text = userModel.user.email;
            _profileController.phoneController.text = userModel.user.phone;
            _profileController.nummberIDController.text = userModel.user.soCccd;
            _profileController.numberVehicleController.text =
                userModel.user.soGplx;
            _profileController.taxCodeController.text =
                userModel.user.masothue ?? 'Chưa đăng ký';
            _profileController.addressController.text = userModel.user.adress;
          }

          return Stack(
            children: [
              Positioned(
                top: 0,
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 7.h, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        Row(
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
                              width: 8.w,
                            ),
                          ],
                        ),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          margin: EdgeInsets.symmetric(vertical: 3.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(
                              15.w,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.w),
                            child: buildAvatar(userModel),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Joined on 12/5/2023",
                            style: PrimaryFont.textCustomBold(2.w).copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Image.asset(
                        //     'assets/image/icon_change_color.png',
                        //     width: 8.w,
                        //     height: 8.w,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 22.h,
                right: 16.h,
                child: GestureDetector(
                  onTap: () {
                    _profileController.pickImageFromGallery();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
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
              Positioned(
                bottom: 0,
                child: Container(
                  width: 100.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.w),
                      topRight: Radius.circular(10.w),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.outer,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 10.w, right: 16.0),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thông tin cá nhân",
                              style: PrimaryFont.bodyTextMedium().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          InputForm(
                            iconStart: HugeIcons.strokeRoundedUserEdit01,
                            readOnly: false,
                            controller: _profileController.nameController,
                            title: l10n.txtNamePU,
                            obscureText: false,
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          InputForm(
                            readOnly: false,
                            iconStart: HugeIcons.strokeRoundedLocation06,
                            controller: _profileController.addressController,
                            title: l10n.txtAddressPU,
                            obscureText: false,
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          InputForm(
                            readOnly: true,
                            suffixIcon: GestureDetector(
                                onTap: () async {
                                  final result = await Get.toNamed(
                                      AppRoutes.updateIdDocument,
                                      arguments: "cccd");
                                  if (result != null && result is String) {
                                    _profileController
                                        .nummberIDController.text = result;
                                  }
                                },
                                child: Icon(
                                  HugeIcons.strokeRoundedSystemUpdate02,
                                  size: 5.w,
                                  color: Colors.red,
                                )),
                            iconStart: HugeIcons.strokeRoundedUserAccount,
                            controller: _profileController.nummberIDController,
                            title: l10n.txtCarIDPU,
                            colorText: Colors.grey,
                            obscureText: false,
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          InputForm(
                            readOnly: true,
                            colorText: Colors.grey,
                            iconStart: HugeIcons.strokeRoundedIdentityCard,
                            controller:
                                _profileController.numberVehicleController,
                            title: l10n.txtVehicleLicensePU,
                            obscureText: false,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await Get.toNamed(
                                  AppRoutes.updateIdDocument,
                                  arguments: "gplx");

                              if (result != null && result is String) {
                                _profileController
                                    .numberVehicleController.text = result;
                              }
                            },
                            child: Container(
                              width: 100.w,
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.w, horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 4,
                                      spreadRadius: 4,
                                      blurStyle: BlurStyle.outer,
                                      offset: Offset(0, 0),
                                      color: Colors.black),
                                ],
                                borderRadius: BorderRadius.circular(5.w),
                              ),
                              child: Transform.translate(
                                offset: const Offset(0, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.w),
                                  child: imageWidget,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Thông tin liên hệ",
                              style: PrimaryFont.bodyTextMedium().copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          InputForm(
                            readOnly: false,
                            iconStart: HugeIcons.strokeRoundedSmartPhone01,
                            controller: _profileController.phoneController,
                            title: l10n.txtPhone,
                            obscureText: false,
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          InputForm(
                            readOnly: false,
                            iconStart: HugeIcons.strokeRoundedMail01,
                            controller: _profileController.emailController,
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
                            height: 10.w,
                          ),
                          ButtonLong(
                            title: l10n.txtUpdateProfilePU,
                            onPressed: () {
                              _profileController.updateUser(
                                {
                                  "name": _profileController.nameController.text
                                      .trim(),
                                  "email": _profileController
                                      .emailController.text
                                      .trim(),
                                  "masothue": null,
                                  "phone": _profileController
                                      .phoneController.text
                                      .trim(),
                                  "soCCCD": _profileController
                                      .nummberIDController.text
                                      .trim(),
                                  "adress": _profileController
                                      .addressController.text
                                      .trim(),
                                  "soGPLX": _profileController
                                      .numberVehicleController.text
                                      .trim(),
                                },
                              );
                            },
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
        },
      ),
    );
  }
}
