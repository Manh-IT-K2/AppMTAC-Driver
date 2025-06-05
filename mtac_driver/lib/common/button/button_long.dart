import 'package:flutter/material.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

class ButtonLong extends StatelessWidget {
  const ButtonLong({super.key, this.onPressed, required this.title});
  final Function()? onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.w),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Text(
          title,
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
