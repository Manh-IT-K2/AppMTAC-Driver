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

  final MapDriverController controller = Get.put(MapDriverController());

  @override
  Widget build(BuildContext context) {
    //double screenHeight = 100.h;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Obx(() {
              if (controller.currentLocation.value == null) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Đang xác định vị trí hiện tại..."),
                  ],
                );
              }

              

              return Stack(
                children: [
                  FlutterMap(
                    mapController: controller.mapController,
                    options: MapOptions(
                      initialCenter: controller.currentLocation.value ??
                          LatLng(10.8231, 106.6297), // Tọa độ mặc định (HCM)
                      initialZoom: 12.0,
                      minZoom: 5,
                      maxZoom: 18,
                      onMapReady: () {
                        // Khi map ready, hiển thị toàn bộ điểm nếu có
                        if (controller.optimizedRoute.isNotEmpty ||
                            controller.currentLocation.value != null) {
                          controller.fitAllPoints();
                        } else {
                          controller.moveToCurrentLocation();
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.app',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      PolylineLayer(
                        polylines: [
                          if (controller.routePoints.isNotEmpty)
                            Polyline(
                              points: controller.routePoints,
                              strokeWidth: 5.0,
                              color: Colors.blueAccent.withOpacity(0.8),
                            ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          // Current location
                          Marker(
                            point: controller.currentLocation.value!,
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                          ),

                          // Optimized route points with numbers
                          ...controller.optimizedRoute
                              .asMap()
                              .entries
                              .where((entry) =>
                                  entry.value !=
                                  controller.currentLocation.value)
                              .map((entry) {
                            int idx = entry.key;
                            LatLng point = entry.value;
                            return Marker(
                              point: point,
                              width: 80,
                              height: 80,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      (idx).toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.optimizedRoute.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "TUYẾN ĐƯỜNG TỐI ƯU",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Hiển thị từng chặng
                                  ...List.generate(
                                      controller.optimizedRoute.length - 1,
                                      (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Chặng ${index + 1}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                if (controller
                                                        .distances.length >
                                                    index)
                                                  Text(
                                                    '${controller.formatDistance(controller.distances[index])} - ${controller.formatDuration(controller.durations[index])}',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const Divider(),
                                  // Tổng cộng
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "TỔNG CỘNG:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${controller.formatDistance(controller.totalDistance.value)} - ${controller.formatDuration(controller.totalDuration.value)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              const Text("Nhấn nút để tối ưu tuyến đường"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: FloatingActionButton(
                      onPressed: () => controller.fitAllPoints(),
                      child: const Icon(Icons.zoom_out_map),
                      mini: true,
                    ),
                  ),
                ],
              );
            }),
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
