import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/common/appbar/app_bar_common.dart';
import 'package:mtac_driver/common/button/button_long.dart';
import 'package:mtac_driver/common/notify/notify_success_dialog.dart';
import 'package:mtac_driver/controller/schedule/handover_record_controller.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/data/map_screen/item_info_waste.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/style_text_util.dart';
import 'package:mtac_driver/widgets/bottom_image_source_sheet.dart';
import 'package:mtac_driver/widgets/schedule_widget/bottom_preview_image_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HandoverRecordDriverScreen extends StatelessWidget {
  HandoverRecordDriverScreen({super.key});

  // Initial _handoverRecordController
  final _handoverRecordController = Get.find<HandoverRecordController>();

  final scheduleController = Get.find<ScheduleController>();
  final scheduleId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // initial AppLocalizations
    final l10n = AppLocalizations.of(context)!;
    //final size = context.screenSize;
    return Scaffold(
      appBar: AppBarCommon(hasMenu: false, title: l10n.txtTitleHR),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderHandoverRecordScreen(
                l10n: l10n,
                controller: _handoverRecordController,
              ),
              _BodyHandoverRecordScreen(
                l10n: l10n,
                sHeightBody: 20.h,
                sHeightItem: 5.h,
                sWidthSizeBox: 4.w,
                sWidthNameWaste: 24.w,
                sWidthCodeWaste: 20.w,
                sWidthStatusWaste: 20.w,
                controller: _handoverRecordController,
              ),
              const SizedBox(
                height: 25,
              ),
              _BottomHandoverRecordSceen(
                l10n: l10n,
                imageController: _handoverRecordController,
                sWidthCon: 30.w,
                sHeightCon: 20.h,
                scheduleController: scheduleController,
                scheduleId: scheduleId,
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomHandoverRecordSceen extends StatelessWidget {
  const _BottomHandoverRecordSceen({
    super.key,
    required this.imageController,
    required this.sWidthCon,
    required this.sHeightCon,
    required this.scheduleController,
    required this.scheduleId,
    required this.l10n,
  });

  final HandoverRecordController imageController;
  final ScheduleController scheduleController;
  final double sWidthCon, sHeightCon;

  final int scheduleId;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "• ${l10n.txtTotalStatuWasteHR} R(${l10n.txtTypeSolidHR}); L(${l10n.txtTypeLiquidHR})",
          style: PrimaryFont.bodyTextThin().copyWith(color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          l10n.txtImageHR,
          style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => const BottomImageSourceSheet(),
                  );
                },
                child: Container(
                  width: sWidthCon,
                  height: sHeightCon,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "+",
                      style: TextStyle(
                          fontSize: 17.w,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Obx(() => imageController.checkDistance.value
                  ? const SizedBox(width: 50)
                  : const SizedBox()),
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => const BottomPreviewImageSheet(),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: imageController.selectedImages
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      File imageFile = entry.value;
                      double rotationAngle = (index - 2) * 0.08;

                      return Dismissible(
                        key: Key(imageFile.path),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          imageController.removeImage(index);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Transform.rotate(
                          angle: rotationAngle,
                          child: Container(
                            width: sWidthCon,
                            height: sHeightCon,
                            margin: EdgeInsets.only(left: index * 0.1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ButtonLong(
          title: l10n.txtButSendHR,
          onPressed: () {
            if (imageController.selectedImages.isNotEmpty &&
                imageController.allInputsValid.value) {
              imageController.updateSelectedGoods(infoWasteData);
              NotifySuccessDialog().showNotifyPopup(
                l10n.txtSuccessNotiHR,
                true,
                () {
                  scheduleController.endCollectionTrip(
                      scheduleId,
                      imageController.selectedGoods,
                      imageController.selectedImages);
                  Navigator.pop(context);
                  Get.back();
                },
              );
            }
          },
        ),
      ],
    );
  }
}

class _BodyHandoverRecordScreen extends StatelessWidget {
  const _BodyHandoverRecordScreen({
    super.key,
    required this.sHeightItem,
    required this.sWidthNameWaste,
    required this.sWidthCodeWaste,
    required this.sWidthStatusWaste,
    required this.sHeightBody,
    required this.sWidthSizeBox,
    required this.controller,
    required this.l10n,
  });

  final AppLocalizations l10n;
  final HandoverRecordController controller;
  final double sHeightBody,
      sHeightItem,
      sWidthNameWaste,
      sWidthCodeWaste,
      sWidthStatusWaste,
      sWidthSizeBox;

  @override
  Widget build(BuildContext context) {
    //
    controller.initializeList(infoWasteData.length);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              l10n.txtNameWasteHR,
              style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
            ),
            Text(
              l10n.txtCodeWasteHR,
              style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
            ),
            Text(
              l10n.txtStatusWasteHR,
              style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
            ),
            Text(
              l10n.txtNumberWasteHR,
              style: PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 3.w,
        ),
        SizedBox(
          height: sHeightBody,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = infoWasteData[index];
                    return Container(
                      height: sHeightItem,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: sWidthSizeBox),
                          SizedBox(
                            width: sWidthNameWaste,
                            child: Text(
                              item.name,
                              style: PrimaryFont.bodyTextLight()
                                  .copyWith(color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: sWidthCodeWaste,
                            child: Text(
                              item.code,
                              style: PrimaryFont.bodyTextLight()
                                  .copyWith(color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: sWidthStatusWaste,
                            child: Obx(() => DropdownButton<String>(
                                  isExpanded: true,
                                  value:
                                      controller.wasteControllers[index].value,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  style: PrimaryFont.bodyTextBold().copyWith(
                                    color: Colors.green,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onChanged: (String? newValue) {
                                    controller.wasteControllers[index].value =
                                        newValue!;
                                  },
                                  items: controller.statusItems
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.showInputPopup(index),
                              child: Obx(
                                () => Text(
                                  controller.numbers[index].value.isEmpty
                                      ? "0 (kg)"
                                      : "${controller.numbers[index].value} (kg)",
                                  style: PrimaryFont.bodyTextLight()
                                      .copyWith(color: Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    );
                  },
                  childCount: infoWasteData.length,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _HeaderHandoverRecordScreen extends StatelessWidget {
  const _HeaderHandoverRecordScreen({
    super.key,
    required this.controller,
    required this.l10n,
  });

  final HandoverRecordController controller;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "${l10n.txtCodeHR} 003437",
            style: PrimaryFont.bodyTextLight().copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            l10n.txtNoteHR,
            style: PrimaryFont.bodyTextLight().copyWith(color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "${l10n.txtTimeHR} ${controller.getFormattedCurrentTime()}",
            style: PrimaryFont.bodyTextLight().copyWith(color: kPrimaryColor),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: double.infinity,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: l10n.txtAddress1HR,
                  style:
                      PrimaryFont.bodyTextLight().copyWith(color: Colors.black),
                ),
                TextSpan(
                  text:
                      " Dự Án Nhà máy sử dụng nước Thải Nhiên liệu Thị Nghè TP.HCM giai đoạn 2.",
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 20),
          width: double.infinity,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: l10n.txtAddress2HR,
                  style:
                      PrimaryFont.bodyTextLight().copyWith(color: Colors.black),
                ),
                TextSpan(
                  text:
                      " Công ty CP Xây Dựng Đê Kè và phát triển Nông Thôn Hải Dương.",
                  style:
                      PrimaryFont.bodyTextBold().copyWith(color: Colors.black),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
