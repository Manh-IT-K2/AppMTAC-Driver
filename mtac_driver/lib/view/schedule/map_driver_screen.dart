import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:mtac_driver/controller/map_controller.dart';
import 'package:mtac_driver/data/map_screen/item_destination.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/text.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class MapDriverScreen extends StatelessWidget {
  MapDriverScreen({super.key});

  final MMapController controller = Get.put(MMapController());

  @override
  Widget build(BuildContext context) {
    //double screenHeight = 100.h;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: GetBuilder<MMapController>(
              builder: (controller) {
                // Tạo bounds từ tất cả các điểm nếu có
                final bounds = controller.routePoints.isNotEmpty
                    ? LatLngBounds.fromPoints([
                        controller.startLocation,
                        ...controller.routePoints,
                        controller.endLocation
                      ])
                    : LatLngBounds(
                        controller.startLocation, controller.endLocation);

                return FlutterMap(
                  options: MapOptions(
                    initialCenter: bounds.center,
                    initialZoom: 12.0,
                    minZoom: 5,
                    maxZoom: 18,
                    onMapReady: () {
                      if (controller.routePoints.isNotEmpty) {
                        final mapController = Get.find<MapController>();
                        mapController.move(
                          bounds.center,
                          mapController.camera
                              .zoom, // Giữ nguyên zoom level hoặc tính toán phù hợp
                        );

                        // Hoặc sử dụng fitCamera nếu phiên bản flutter_map hỗ trợ
                        mapController.fitCamera(
                          CameraFit.bounds(
                            bounds: bounds,
                            padding: EdgeInsets.all(50),
                          ),
                        );
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      // Bỏ subdomains để tránh cảnh báo
                      userAgentPackageName: 'com.example.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        if (controller.routePoints.isNotEmpty)
                          Polyline(
                            points: [
                              controller.startLocation,
                              ...controller.routePoints,
                              controller.endLocation
                            ],
                            strokeWidth: 5.0, // Tăng độ dày
                            color: Colors.blueAccent
                                .withOpacity(0.8), // Màu nổi bật
                          ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        // Điểm bắt đầu
                        Marker(
                          point: controller.startLocation,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 50.0,
                          ),
                        ),
                        // Điểm kết thúc
                        Marker(
                          point: controller.endLocation,
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.green,
                            size: 50.0,
                          ),
                        ),
                        // Các điểm trung gian (chỉ hiển thị 1 số điểm quan trọng)
                        ...controller.routePoints
                            .asMap()
                            .entries
                            .where((entry) =>
                                entry.key % 50 ==
                                0) // Lấy mỗi 50 điểm để tránh quá nhiều marker
                            .map((entry) => Marker(
                                  point: entry.value,
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.orange,
                                    size: 50.0,
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ],
                );
              },
            ),
          )

          // Positioned(
          //   top: 15.w,
          //   left: 5.w,
          //   child: GestureDetector(
          //     onTap: () => Get.back(),
          //     child: Container(
          //       width: 10.w,
          //       height: 10.w,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           shape: BoxShape.circle,
          //           boxShadow: [
          //             BoxShadow(
          //                 color: Colors.black.withOpacity(0.1),
          //                 spreadRadius: 4,
          //                 blurRadius: 4,
          //                 offset: const Offset(1, 1))
          //           ]),
          //       child: Transform.translate(
          //         offset: const Offset(4, 0),
          //         child: Icon(
          //           Icons.arrow_back_ios,
          //           size: 5.w,
          //           color: kPrimaryColor,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Obx(() {
          //   if (1 == 1
          //     //controller.isRouteSelected.value
          //     ) {
          //     return Positioned(
          //       bottom: 80,
          //       left: 20,
          //       right: 20,
          //       child: Container(
          //         padding: const EdgeInsets.all(10),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(10),
          //           boxShadow: const [
          //             BoxShadow(
          //               color: Colors.black26,
          //               blurRadius: 5,
          //             )
          //           ],
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Align(
          //               alignment: Alignment.topRight,
          //               child: GestureDetector(
          //                 onTap: () {},
          //                 //controller.isRouteSelected.value = false,
          //                 child: Icon(
          //                   Icons.close,
          //                   size: 4.w,
          //                   color: Colors.red,
          //                 ),
          //               ),
          //             ),
          //             Text(
          //               'controller.selectedAddress.value',
          //               style: const TextStyle(fontWeight: FontWeight.bold),
          //             ),
          //             const SizedBox(height: 10),
          //             ElevatedButton(
          //               onPressed: (){},
          //               //controller.openGoogleMaps,
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: kPrimaryColor.withOpacity(0.6),
          //                 foregroundColor: Colors.white,
          //                 padding: EdgeInsets.symmetric(
          //                     horizontal: 5.w, vertical: 1.w),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(100.w),
          //                 ),
          //                 elevation: 5,
          //               ),
          //               child: Text(
          //                 "Đi đến vị trí",
          //                 style: PrimaryFont.bodyTextBold(),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   }
          //   return const SizedBox.shrink();
          // }),

          // // Draggable Bottom Sheet
          // Obx(
          //   () => Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: GestureDetector(
          //       onVerticalDragUpdate: (details) {
          //         controller.updateHeight(details.primaryDelta!, screenHeight);
          //       },
          //       child: Container(
          //         height: screenHeight * controller.sheetHeight.value,
          //         decoration: const BoxDecoration(
          //           color: Colors.white,
          //           borderRadius:
          //               BorderRadius.vertical(top: Radius.circular(20)),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black26,
          //               blurRadius: 10,
          //             ),
          //           ],
          //         ),
          //         child: Column(
          //           children: [
          //             Container(
          //               width: 35.w,
          //               height: 1.w,
          //               margin: const EdgeInsets.symmetric(vertical: 10),
          //               decoration: BoxDecoration(
          //                 color: Colors.black,
          //                 borderRadius: BorderRadius.circular(10),
          //               ),
          //             ),
          //             Expanded(
          //               child: SingleChildScrollView(
          //                 physics: const BouncingScrollPhysics(),
          //                 child: Column(
          //                   children: [
          //                     Text(
          //                       txtTitleBottomM,
          //                       style: PrimaryFont.headerTextBold().copyWith(
          //                         color: const Color(0xFF233751),
          //                       ),
          //                     ),
          //                     Row(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         SizedBox(
          //                           width: 5.w,
          //                         ),
          //                         Column(
          //                           children: [
          //                             SizedBox(
          //                               height: 8.h,
          //                             ),
          //                             Container(
          //                               width: 3.w,
          //                               height: 3.w,
          //                               decoration: BoxDecoration(
          //                                 color: kPrimaryColor,
          //                                 borderRadius:
          //                                     BorderRadius.circular(3.w),
          //                               ),
          //                             ),
          //                             Container(
          //                               width: 0.5.w,
          //                               height: 50.w,
          //                               color: kPrimaryColor,
          //                             ),
          //                             Container(
          //                               width: 3.w,
          //                               height: 3.w,
          //                               decoration: BoxDecoration(
          //                                 color: Colors.grey.withOpacity(0.5),
          //                                 borderRadius:
          //                                     BorderRadius.circular(3.w),
          //                               ),
          //                             ),
          //                             Container(
          //                               width: 0.5.w,
          //                               height: 50.w,
          //                               color: Colors.grey,
          //                             ),
          //                             Container(
          //                               width: 3.w,
          //                               height: 3.w,
          //                               decoration: BoxDecoration(
          //                                 color: Colors.grey.withOpacity(0.5),
          //                                 borderRadius:
          //                                     BorderRadius.circular(3.w),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                         SizedBox(width: 5.w),
          //                         Expanded(
          //                           child: ListView.builder(
          //                             shrinkWrap: true,
          //                             physics:
          //                                 const NeverScrollableScrollPhysics(),
          //                             scrollDirection: Axis.vertical,
          //                             itemCount: itemDestinationData.length,
          //                             itemBuilder: (context, index) {
          //                               final destination =
          //                                   itemDestinationData[index];
          //                               return _ItemDestination(
          //                                 addressBusiness:
          //                                     destination.addressBusiness,
          //                                 numberBD: destination.numberBD,
          //                                 status: destination.status,
          //                                 totalWeight: destination.totalWeight,
          //                                 phonePartner:
          //                                     destination.phonePartner,
          //                                 namePartner: destination.namePartner,
          //                                 note: destination.note,
          //                                 isLastItem: index ==
          //                                     itemDestinationData.length - 1,
          //                                 onTap: () {
          //                                   // controller.makePhoneCall(
          //                                   //     destination.phonePartner);
          //                                   // if (kDebugMode) {
          //                                   //   print("Call with me!");
          //                                   // }
          //                                 },
          //                               );
          //                             },
          //                           ),
          //                         ),
          //                         SizedBox(
          //                           width: 10.w,
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class _ItemDestination extends StatelessWidget {
  _ItemDestination({
    super.key,
    required this.addressBusiness,
    required this.numberBD,
    required this.status,
    required this.totalWeight,
    required this.phonePartner,
    required this.namePartner,
    required this.note,
    required this.isLastItem,
    this.onTap,
  });

  final String addressBusiness,
      numberBD,
      status,
      totalWeight,
      phonePartner,
      namePartner,
      note;
  final bool isLastItem;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.w),
        Text(
          addressBusiness,
          style: PrimaryFont.titleTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        Text(
          "+BD: $numberBD",
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        Text(
          "+CC: $totalWeight",
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        Text(
          "GOM: $status",
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        Text(
          note,
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              namePartner,
              style: PrimaryFont.bodyTextBold().copyWith(
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (onTap != null) {
                  if (kDebugMode) {
                    print("onTap function is called!");
                  }
                  onTap!();
                } else {
                  if (kDebugMode) {
                    print("onTap is null!");
                  }
                }
              },
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.edit_square,
              color: const Color(0xFF997FEC),
              size: 5.w,
            ),
            SizedBox(
              width: 2.w,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.handoverRecord);
              },
              child: Text(
                txtWriteRecordM,
                style: PrimaryFont.bodyTextBold().copyWith(
                  color: const Color(0xFF997FEC),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.w,
        ),
        if (!isLastItem)
          Icon(
            Icons.arrow_downward,
            color: kPrimaryColor,
            size: 5.w,
          ),
      ],
    );
  }
}
