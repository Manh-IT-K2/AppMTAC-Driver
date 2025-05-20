import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/schedule/handover_record_controller.dart';
import 'package:mtac_driver/utils/text_util.dart';
import 'package:mtac_driver/utils/style_text_util.dart';


class BottomImageSourceSheet extends StatelessWidget {
  const BottomImageSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final imageController = Get.find<HandoverRecordController>();

    return Wrap(
      children: [
        ListTile(
          leading: const Icon(HugeIcons.strokeRoundedImage02),
          title: Text(txtLibrary,
              style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black)),
          onTap: () {
            imageController.pickMultipleImages();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(HugeIcons.strokeRoundedCamera02),
          title: Text(
            txtCamera,
            style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
          ),
          onTap: () {
            imageController.pickImageFromCamera();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
