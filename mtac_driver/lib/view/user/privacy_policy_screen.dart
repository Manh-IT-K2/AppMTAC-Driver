import 'package:flutter/material.dart';
import 'package:mtac_driver/utils/style_text_util.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Privacy Plicy",
        style: PrimaryFont.bodyTextBold(),
      ),
    );
  }
}
