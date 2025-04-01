import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtac_driver/common/notify_success_dialog.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class HandoverRecordController extends GetxController {
  /* CODE DROPDOWN CHOOSE STATUS */
  var wasteControllers = <RxString>[].obs;
  final List<String> statusItems = [
    "Null",
    "Chưa thu gom",
    "Đang thu gom",
    "Đã thu gom"
  ];

  void initializeDropdowns(int length) {
    wasteControllers.assignAll(List.generate(length, (_) => "Null".obs));
  }
  // void initializeDropdowns(List<WasteModel> infoWasteData) {
  // wasteControllers.assignAll(
  //   infoWasteData.map((item) => item.status.obs).toList()
  // );
  //}

  /* CODE CHOSE IMAGE */
  // Create variable image
  final ImagePicker _picker = ImagePicker();
  var selectedImages = <File>[].obs;
  var checkDistance = false.obs;

  // Selected image library
  Future<void> pickMultipleImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      List<File> newImages = images.map((img) => File(img.path)).toList();
      // filter image name
      final Set<String> fileNames =
          selectedImages.map((file) => file.path.split('/').last).toSet();
      for (var img in newImages) {
        if (!fileNames.contains(img.path.split('/').last)) {
          selectedImages.add(img);
        }
      }
      checkDistance.value = selectedImages.isNotEmpty;
      //selectedImages.refresh();
      //print("Selected Images: ${selectedImages.map((e) => e.path).toList()}");
    }
  }

  // Open Camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImages.add(File(image.path));
      checkDistance.value = selectedImages.isNotEmpty;
      //selectedImages.refresh();
    }
  }

  // Renove image from index
  void removeImage(int index) {
    selectedImages.removeAt(index);
    checkDistance.value = selectedImages.isNotEmpty;
  }

  /* CODE INPUT */

  // Create variable input
  var numbers = <RxString>[].obs;
  var status = false.obs;
  var textController = TextEditingController();

  void initializeList(int length) {
    numbers.assignAll(List.generate(length, (index) => "".obs));
    initializeDropdowns(length);
  }

  void showInputPopup(int index) {
    textController.text = numbers[index].value;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(top: 10.w),
                  width: 90.w,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: kPrimaryColor, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            status.value = false;
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 3.w,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Thêm dữ liệu",
                        style: PrimaryFont.headerTextBold()
                            .copyWith(color: kPrimaryColor),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "Khối lượng",
                        style: PrimaryFont.bodyTextMedium()
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(height: 1.w),
                      SizedBox(
                        height: 10.w,
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: "Nhập khối lượng",
                            hintStyle: PrimaryFont.bodyTextMedium()
                                .copyWith(color: Colors.grey),
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: Container(
                              alignment: Alignment.center,
                              width: 40,
                              child: Text(
                                "kg",
                                style: PrimaryFont.bodyTextMedium()
                                    .copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      SizedBox(height: 1.w),
                      Obx(
                        () => status.value
                            ? Text(
                                "Chưa nhập khối lượng",
                                style: PrimaryFont.bodyTextMedium()
                                    .copyWith(color: Colors.red),
                              )
                            : const SizedBox(),
                      ),
                      SizedBox(height: 10.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (textController.text.isNotEmpty &&
                                  !textController.text.contains("Not value")) {
                                numbers[index].value = textController.text;
                                status.value = false;
                                Navigator.pop(Get.context!);
                                Future.delayed(const Duration(milliseconds: 300), () {
                                  NotifySuccessDialog().showNotifyPopup(
                                    "Thêm khối lượng thành công",
                                    () => Navigator.pop(Get.context!),
                                  );
                                });
                              } else {
                                status.value = true;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              elevation: 5,
                              minimumSize: Size(15.h, 5.h),
                            ),
                            child: Text(
                              "Thêm",
                              style: PrimaryFont.bodyTextBold()
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
