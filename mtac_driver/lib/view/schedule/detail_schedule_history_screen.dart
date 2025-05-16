import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class DetailScheduleHistoryScreen extends StatelessWidget {
  const DetailScheduleHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: 100.w,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  HugeIcons.strokeRoundedArrowLeft01,
                  size: 8.w,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  "Chi tiết lịch gom",
                  textAlign: TextAlign.center,
                  style: PrimaryFont.headerTextBold()
                      .copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Ngày: 2025-05-16",
                    style: PrimaryFont.bodyTextBold(),
                  ),
                  const Spacer(),
                  Text(
                    "Mã: TG-017",
                    style:
                        PrimaryFont.bodyTextBold().copyWith(color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 3.w,
              ),
              Container(
                width: 100.w,
                height: 15.h,
                margin: EdgeInsets.only(bottom: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: const Column(
                  children: [
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedOffice,
                      title: "Tên công ty: ",
                      content: "Bệnh viện Xanh Pôn",
                      colorContent: Colors.black,
                    ),
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedLocation04,
                      title: "Địa chỉ: ",
                      content: "Quận Ba Đình, Hà Nội",
                      colorContent: Colors.black,
                    ),
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedWaste,
                      title: "Loại chất thải: ",
                      content: "Chất thải y tế",
                      colorContent: Colors.green,
                    ),
                  ],
                ),
              ),
              Text(
                "Chi tiết xe tải",
                style: PrimaryFont.titleTextBold(),
              ),
              Container(
                width: 100.w,
                height: 10.h,
                margin: EdgeInsets.only(top: 2.w, bottom: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.w),
                ),
                child: const Column(
                  children: [
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedShippingTruck01,
                      title: "Tên xe: ",
                      content: "Hyundai-0123",
                      colorContent: Colors.black,
                    ),
                    _itemCollectionDetail(
                      icon: HugeIcons.strokeRoundedEdgeStyle,
                      title: "Biển số: ",
                      content: "29H1-12345",
                      colorContent: Colors.black,
                    ),
                  ],
                ),
              ),
              Text(
                "Chi tiết hàng hoá",
                style: PrimaryFont.titleTextBold(),
              ),
              SizedBox(
                height: 5.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Tên loại rác",
                    style: PrimaryFont.bodyTextBold(),
                  ),
                  Text(
                    "Số lượng",
                    style: PrimaryFont.bodyTextBold(),
                  ),
                ],
              ),
              SizedBox(
                height: 3.w,
              ),
              SizedBox(
                width: 100.w,
                height: 20.h,
                child: ListView(
                  children: List.generate(
                    4,
                    (index) {
                      return Container(
                        width: 100.w,
                        height: 10.w,
                        margin:
                            EdgeInsets.only(left: 5.w, right: 5.w, bottom: 2.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: kPrimaryColor.withOpacity(0.3), width: 1),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Tên loại rác",
                              style: PrimaryFont.bodyTextBold(),
                            ),
                            Text(
                              "Số lượng",
                              style: PrimaryFont.bodyTextBold(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5.w,
              ),
              Text(
                "Chi tiết hình ảnh",
                style: PrimaryFont.titleTextBold(),
              ),
              SizedBox(
                width: 100.w,
                height: 30.w,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((contex, index) {
                        return Padding(
                          padding: EdgeInsets.all(2.w),
                          child: Image.asset(
                            "assets/image/truck-detail.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      }, childCount: 5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _itemCollectionDetail extends StatelessWidget {
  const _itemCollectionDetail({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.colorContent,
  });
  final IconData icon;
  final Color? colorContent;
  final String title, content;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 5.w,
            color: Colors.black,
          ),
          SizedBox(
            width: 2.w,
          ),
          Text(
            title,
            style: PrimaryFont.bodyTextMedium().copyWith(color: Colors.black),
          ),
          Expanded(
            child: Text(
              content,
              style: PrimaryFont.bodyTextMedium().copyWith(color: colorContent),
            ),
          ),
        ],
      ),
    );
  }
}
