import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryFont {
  static String fontfamily = 'Manrope';

  // text header
  static TextStyle headerTextThin() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w100,
      fontSize: 5.w,
    );
  }

  static TextStyle headerTextLight() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w300,
      fontSize: 5.w,
    );
  }

  static TextStyle headerTextMedium() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w500,
      fontSize: 5.w,
    );
  }

  static TextStyle headerTextBold() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w700,
      fontSize: 5.w,
    );
  }

  // text body
  static TextStyle bodyTextThin() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w100,
      fontSize: 3.w,
    );
  }

  static TextStyle bodyTextLight() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w300,
      fontSize: 3.w,
    );
  }

  static TextStyle bodyTextMedium() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w500,
      fontSize: 3.w,
    );
  }

  static TextStyle bodyTextBold() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w700,
      fontSize: 3.w,
    );
  }

// text body
  static TextStyle titleTextThin() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w100,
      fontSize: 4.w,
    );
  }

  static TextStyle titleTextLight() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w300,
      fontSize: 4.w,
    );
  }

  static TextStyle titleTextMedium() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w500,
      fontSize: 4.w,
    );
  }

  static TextStyle titleTextBold() {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w700,
      fontSize: 4.w,
    );
  }

  // text note
  static TextStyle textCustomThin(double size) {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w100,
      fontSize: size,
    );
  }

  static TextStyle textCustomLight(double size) {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w300,
      fontSize: size,
    );
  }

  static TextStyle textCustomMedium(double size) {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w500,
      fontSize: size,
    );
  }

  static TextStyle textCustomBold(double size) {
    return TextStyle(
      fontFamily: fontfamily,
      fontWeight: FontWeight.w700,
      fontSize: size,
    );
  }
}

extension GetOrientation on BuildContext {
  Orientation get orientation => MediaQuery.of(this).orientation;
}

extension GetSize on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}
