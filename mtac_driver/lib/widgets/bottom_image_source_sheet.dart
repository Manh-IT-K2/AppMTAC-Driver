import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/controller/schedule/handover_record_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mtac_driver/utils/style_text_util.dart';

class BottomImageSourceSheet extends StatelessWidget {
  const BottomImageSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final imageController = Get.find<HandoverRecordController>();
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(HugeIcons.strokeRoundedImage02),
          title: Text(l10n.txtLibrary,
              style:
                  PrimaryFont.bodyTextMedium().copyWith(color: Colors.black)),
          onTap: () {
            imageController.pickMultipleImages();
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(HugeIcons.strokeRoundedCamera02),
          title: Text(
            l10n.txtCamera,
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
