import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:mtac_driver/utils/style_text_util.dart';

class AppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCommon(
      {super.key, required this.hasMenu, this.onTap, required this.title});
  final bool hasMenu;
  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
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
              title,
              textAlign: TextAlign.center,
              style: PrimaryFont.headerTextBold().copyWith(color: Colors.black),
            ),
          ),
          hasMenu
              ? GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ]),
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 5.w,
                    ),
                  ),
                )
              : SizedBox(
                  width: 8.w,
                ),
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}
