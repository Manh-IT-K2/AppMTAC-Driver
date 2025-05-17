import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  //
  final _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SizedBox(
          width: 100.w,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  HugeIcons.strokeRoundedArrowLeft01,
                  size: 8.w,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  "Contact Us",
                  textAlign: TextAlign.center,
                  style: PrimaryFont.headerTextBold()
                      .copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => Column(
              children: [
                _itemContactUsAccount(
                  title: "Customer service",
                  subTitle: "info@moitruongachau.com",
                  arrowDownContactUs: _loginController.arrowDownService.value,
                  ontap: () =>
                      _loginController.toggleArrowDownServiceVisibility(),
                  icon: HugeIcons.strokeRoundedCustomerService01,
                ),
                _itemContactUsAccount(
                  title: "WhatsApp",
                  subTitle: "(+84) 36 285 1122",
                  arrowDownContactUs: _loginController.arrowDownWhatsApp.value,
                  ontap: () =>
                      _loginController.toggleArrowDownWhatsAppVisibility(),
                  icon: HugeIcons.strokeRoundedWhatsapp,
                ),
                _itemContactUsAccount(
                  title: "Website",
                  subTitle: "www.moitruongachau.com",
                  arrowDownContactUs: _loginController.arrowDownWebsite.value,
                  ontap: () =>
                      _loginController.toggleArrowDownWebsiteVisibility(),
                  icon: HugeIcons.strokeRoundedInternet,
                ),
                _itemContactUsAccount(
                  title: "Linked",
                  subTitle:
                      "https://www.linkedin.com/company/a-chau-environment",
                  arrowDownContactUs: _loginController.arrowDownTwitter.value,
                  ontap: () =>
                      _loginController.toggleArrowDownTwitterVisibility(),
                  icon: HugeIcons.strokeRoundedLinkedin01,
                ),
                _itemContactUsAccount(
                  title: "Email",
                  subTitle: "info@moitruongachau.com",
                  arrowDownContactUs: _loginController.arrowDownInstagram.value,
                  ontap: () =>
                      _loginController.toggleArrowDownInstagramVisibility(),
                  icon: HugeIcons.strokeRoundedMail01,
                ),
                _itemContactUsAccount(
                  title: "Facebook",
                  subTitle: "https://www.facebook.com/MoiTruongAChau",
                  arrowDownContactUs: _loginController.arrowDownFacebook.value,
                  ontap: () =>
                      _loginController.toggleArrowDownFacebookVisibility(),
                  icon: HugeIcons.strokeRoundedFacebook02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _itemContactUsAccount extends StatelessWidget {
  const _itemContactUsAccount({
    super.key,
    required this.arrowDownContactUs,
    required this.title,
    required this.subTitle,
    required this.icon,
    this.ontap,
  });

  final bool arrowDownContactUs;
  final String title, subTitle;
  final IconData icon;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: arrowDownContactUs ? 25.w : 12.w,
      margin: EdgeInsets.only(bottom: 3.w),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: kPrimaryColor.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 5.w,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Expanded(
                    child: Text(
                  title,
                  style: PrimaryFont.bodyTextMedium()
                      .copyWith(color: Colors.black),
                )),
                GestureDetector(
                  onTap: ontap,
                  child: Icon(
                    arrowDownContactUs
                        ? HugeIcons.strokeRoundedArrowUp01
                        : HugeIcons.strokeRoundedArrowDown01,
                    size: 5.w,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            arrowDownContactUs
                ? Container(
                    width: 100.w,
                    height: 0.2,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(vertical: 3.w),
                  )
                : const SizedBox(),
            arrowDownContactUs
                ? Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        "•",
                        style: PrimaryFont.titleTextBold()
                            .copyWith(color: Colors.black),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            subTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: PrimaryFont.bodyTextMedium().copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
