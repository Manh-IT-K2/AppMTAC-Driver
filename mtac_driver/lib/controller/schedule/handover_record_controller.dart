import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mtac_driver/model/waste_model.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  RxList<File> selectedImages = <File>[].obs;
  var checkDistance = false.obs;

  // Selected image library
  Future<void> pickMultipleImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      List<File> newImages = [];
      final Set<String> fileNames =
          selectedImages.map((file) => file.path.split('/').last).toSet();

      for (var img in images) {
        if (!fileNames.contains(img.path.split('/').last)) {
          // Compress the image before adding
          File compressedFile = await compressImage(File(img.path));
          newImages.add(compressedFile);
        }
      }

      selectedImages.addAll(newImages);
      checkDistance.value = selectedImages.isNotEmpty;
    }
  }

  // Open Camera
  Future<void> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Compress the image before adding
      File compressedFile = await compressImage(File(image.path));
      selectedImages.add(compressedFile);
      checkDistance.value = selectedImages.isNotEmpty;
    }
  }

  // Function to compress image
  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 800, // Resize width
      minHeight: 600, // Resize height
      quality: 80, // Quality of the image (lower = smaller file size)
      rotate: 0,
    );

    // Create a new file from the compressed data
    final compressedFile = File(file.path)..writeAsBytesSync(result!);
    return compressedFile;
  }

  // Renove image from index
  void removeImage(int index) {
    selectedImages.removeAt(index);
    checkDistance.value = selectedImages.isNotEmpty;
  }

    // Renove all image from index
  void removeAllImage() {
    selectedImages.clear();
  }

  /* CODE INPUT */

  // Create variable input
  var numbers = <RxString>[].obs;
  var status = false.obs;
  var textController = TextEditingController();

  //
  var allInputsValid = false.obs;
  void validateAllInputs() {
    allInputsValid.value = numbers.every(
      (element) =>
          element.value.trim().isNotEmpty && element.value.trim() != "0",
    );
  }
  //
  Future<void> calculateAndSaveTotalKg() async {
    double totalKg = 0;

    for (var item in numbers) {
      final value = double.tryParse(item.value.trim());
      if (value != null && value > 0) {
        totalKg += value;
      }
    }

    // Lưu vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('total_kg', totalKg);

    if (kDebugMode) {
      print('✅ Tổng số kg: $totalKg đã được lưu vào local.');
    }
  }

  // 
  Future<double> getTotalKgFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('total_kg') ?? 0.0;
  }

  void initializeList(int length) {
    numbers.assignAll(List.generate(length, (index) => "".obs));
    initializeDropdowns(length);
  }

  RxList<Map<String, dynamic>> selectedGoods = <Map<String, dynamic>>[].obs;

// Danh sách ảnh được chọn từ gallery/camera

  //
  void updateSelectedGoods(List<WasteModel> infoWasteData) {
    selectedGoods.clear();

    for (int i = 0; i < infoWasteData.length; i++) {
      final quantityStr = numbers[i].value.trim();
      final quantity = double.tryParse(quantityStr);
      final name = infoWasteData[i].name;

      if (quantity != null && quantity > 0) {
        selectedGoods.add({
          "name": name,
          "quantity": quantity,
        });
      }
    }
  }

  //
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
                                validateAllInputs(); //
                                Navigator.pop(Get.context!);
                                // Future.delayed(const Duration(milliseconds: 300), () {
                                //   NotifySuccessDialog().showNotifyPopup(
                                //     "Thêm khối lượng thành công",
                                //     () => Navigator.pop(Get.context!),
                                //   );
                                // });
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
