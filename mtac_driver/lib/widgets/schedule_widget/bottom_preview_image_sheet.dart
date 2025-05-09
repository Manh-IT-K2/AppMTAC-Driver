import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/controller/schedule/handover_record_controller.dart';
import 'package:sizer/sizer.dart';

class BottomPreviewImageSheet extends StatelessWidget {
  const BottomPreviewImageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Get.find<HandoverRecordController>();

    return Container(
      padding: const EdgeInsets.all(10),
      width: 100.w,
      height: 70.h,
      child: Obx(
        () {
          return CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            imageController.selectedImages[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 3.w,
                          left: 3.w,
                          child: GestureDetector(
                            onTap: () {
                              imageController.removeImage(index);
                              if (imageController.selectedImages.isEmpty) {
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 8.w,
                              width: 8.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 4.w,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: imageController.selectedImages.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
