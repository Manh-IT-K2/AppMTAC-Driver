import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class InputForm extends StatelessWidget {
  InputForm(
      {super.key,
      required this.controller,
      required this.title,
      this.iconStart,
      this.suffixIcon,
      this.validator,
      this.onChanged,
      this.keyboardType,
      this.inputFormatters,
      this.showCursor,
      this.colorText,
      required this.readOnly,
      required this.obscureText});

  final TextEditingController controller;
  final String title;
  IconData? iconStart;
  Widget? suffixIcon;
  bool obscureText;
  bool readOnly;
  bool? showCursor;
  Color? colorText;
  String? Function(String?)? validator;
  Function(String)? onChanged;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      showCursor: showCursor,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      style: PrimaryFont.bodyTextMedium().copyWith(color: colorText),
      cursorColor: kPrimaryColor.withOpacity(0.5),
      decoration: InputDecoration(
        labelText: title,
        labelStyle:
            PrimaryFont.bodyTextMedium().copyWith(color: Colors.blueAccent),
        prefixIcon: Icon(iconStart, color: Colors.blueAccent, size: 5.w,),
        filled: true,
        fillColor: Colors.blue.shade50,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
