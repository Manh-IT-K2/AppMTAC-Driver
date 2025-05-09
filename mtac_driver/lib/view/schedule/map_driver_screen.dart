import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:mtac_driver/controller/schedule/map_controller.dart';
import 'package:mtac_driver/controller/schedule/schedule_controller.dart';
import 'package:mtac_driver/model/destination_model.dart';
import 'package:mtac_driver/model/schedule_model.dart';
import 'package:mtac_driver/route/app_route.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/text.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:mtac_driver/widgets/schedule_widget/moving_gif_widget.dart';
import 'package:sizer/sizer.dart';

class MapDriverScreen extends StatelessWidget {
  MapDriverScreen({super.key});

  // initial MapDriverController
  final MapDriverController controller = Get.put(MapDriverController());
  final scheduleController = Get.find<ScheduleController>();

  //final int tripId = Get.arguments as int;

  @override
  Widget build(BuildContext context) {
    double screenHeight = 100.h;
    //final destinationsData = controller.getDestinationsByTripId(controller.tripId);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Obx(
              () {
                if (controller.optimizedRoute.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Image.asset(
                        "assets/image/loadingTruck.gif",
                        width: 40,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 16),
                      const Text("Đang tối ưu tuyến đường...."),
                    ],
                  );
                }
                return FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: controller.currentLocation.value ??
                        const LatLng(10.8231, 106.6297), // HCM
                    initialZoom: 12.0,
                    minZoom: 5,
                    maxZoom: 18,
                    onMapReady: () {
                      // when map ready display full point if have
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
                        // Current location marker
                        Marker(
                          point: controller.currentLocation.value!,
                          width: 60,
                          height: 60,
                          child: const Icon(
                            HugeIcons.strokeRoundedGps01,
                            color: kPrimaryColor,
                            size: 30.0,
                          ),
                        ),

                        // Optimized route points
                        ...controller.optimizedRoute
                            .asMap()
                            .entries
                            .where((entry) {
                          final current = controller.currentLocation.value;
                          return current == null ||
                              current.latitude != entry.value.latitude ||
                              current.longitude != entry.value.longitude;
                        }).map((entry) {
                          int idx = entry.key;
                          LatLng point = entry.value;
                          bool isLast =
                              idx == controller.optimizedRoute.length - 1;
                          return Marker(
                            point: point,
                            width: 60,
                            height: 80,
                            child:
                                _buildCustomMarker(idx, point, isLast: isLast),
                          );
                        }),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          //
          Positioned(
            top: 15.w,
            right: 5.w,
            child: GestureDetector(
              onTap: () => controller.fitAllPoints(),
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: const Offset(1, 1))
                    ]),
                child: Icon(
                  HugeIcons.strokeRoundedArrowShrink,
                  size: 5.w,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),

          //
          Positioned(
            top: 15.w,
            left: 5.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 4,
                          blurRadius: 4,
                          offset: const Offset(1, 1))
                    ]),
                child: Transform.translate(
                  offset: const Offset(4, 0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 5.w,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          ),

          // Draggable Bottom Sheet
          Obx(
            () => Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  controller.updateHeight(details.primaryDelta!, screenHeight);
                },
                child: Container(
                  height: screenHeight * controller.sheetHeight.value,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        //padding: EdgeInsets.symmetric(vertical: 50),
                        alignment: Alignment.topCenter,
                        width: 35.w,
                        height: 1.w,
                        margin: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Text(
                                txtTitleBottomM,
                                style: PrimaryFont.headerTextBold().copyWith(
                                  color: const Color(0xFF233751),
                                ),
                              ),
                              controller.optimizedRoute.isNotEmpty
                                  ? Text(
                                      "${controller.formatDistance(controller.totalDistance.value)} - ${controller.formatDuration(controller.totalDuration.value)}",
                                      style: PrimaryFont.titleTextMedium()
                                          .copyWith(
                                        color: Colors.red,
                                      ),
                                    )
                                  : const SizedBox(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      _buildRouteDots(),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: _buildDestinationList(),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // initial widget
  Widget _buildCustomMarker(int index, LatLng point, {bool isLast = false}) {
    return GestureDetector(
      onTap: () => _showWeightInputDialog(Get.context!, point),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hiển thị khối lượng nếu có
          if (controller.weightMarkers[point] != null)
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                '${controller.weightMarkers[point]} kg',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          // Marker
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
              Positioned(
                top: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: isLast
                      ? Icon(
                          HugeIcons.strokeRoundedPackage03,
                          size: 5.w,
                          color: Colors.red,
                        )
                      : Text(
                          '$index',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //
  Widget _buildDestinationList() {
    if (controller.optimizedRoute.isNotEmpty) {
      // sort
      sortItemDestinationDataByOptimizedRoute();
      // data by id
      //final destinationData = controller.getDestinationsByTripId(tripId);
      return CustomScrollView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 5.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final destination = controller.destinationsData[index];
                  final distanceTime = index < controller.distances.length
                      ? '${controller.formatDistance(controller.distances[index])} - ${controller.formatDuration(controller.durations[index])}'
                      : '';

                  return _ItemDestination(
                    scheduleId: destination.id,
                    distanceTime: distanceTime,
                    nameBusiness: destination.companyName,
                    //numberBD: destination.numberBD,
                    area: destination.area,
                    typeWate: destination.wasteType,
                    //totalWeight: destination.,
                    //phonePartner: destination.phonePartner,
                    //namePartner: destination.namePartner,
                    //note: destination.note,
                    isLastItem: index == controller.destinationsData.length - 1,
                    onTap: () {
                      //controller.makePhoneCall(destination.phonePartner);
                      scheduleController.startTrip(destination.id);
                    },
                    controller: scheduleController,
                  );
                },
                childCount: controller.destinationsData.length,
              ),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Image.asset(
          "assets/image/loadingDot.gif",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //
  void _showWeightInputDialog(BuildContext context, LatLng position) {
    final TextEditingController weightController = TextEditingController();
    var errText = "".obs;
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
                          controller: weightController,
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
                        () => controller.statusInputWeight.value
                            ? Text(
                                errText.value,
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
                              if (weightController.text.isNotEmpty) {
                                int a = int.parse(weightController.text);
                                if (a < 50000) {
                                  controller.statusInputWeight.value = false;
                                  controller.updateWeight(
                                      position, weightController.text);
                                  Navigator.pop(context);
                                } else {
                                  controller.statusInputWeight.value = true;
                                  errText.value =
                                      "Khối lượng không lớn hơn 50.000 kg";
                                }
                              } else {
                                controller.statusInputWeight.value = true;
                                errText.value = "Chưa nhập khối lượng";
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

  // sort
  void sortItemDestinationDataByOptimizedRoute() {
    //
    final locationToDestination = <String, Datum>{};
    //
    //final destinationData = controller.getDestinationsByTripId(tripId);
    //
    for (final dest in controller.destinationsData) {
      final key = "${dest.latitude}_${dest.longitude}";
      locationToDestination[key] = dest;
    }

    final sorted = controller.optimizedRoute
        .map((latLng) {
          final key = "${latLng.latitude}_${latLng.longitude}";
          return locationToDestination[key];
        })
        .whereType<Datum>()
        .toList();

    controller.destinationsData
      ..clear()
      ..addAll(sorted);

    if (kDebugMode) {
      print(
          "✅ Đã sắp xếp lại itemDestinationData theo optimizedRoute: ${controller.destinationsData.length}");
    }
  }

  //
  Widget _buildRouteDots() {
    return controller.optimizedRoute.isNotEmpty
        ? Column(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              Container(
                width: 0.5.w,
                height: 40.w,
                color: kPrimaryColor,
              ),
              ...List.generate(
                controller.destinationsData.length - 2,
                (index) => Column(
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                    ),
                    Container(
                      width: 0.5.w,
                      height: 40.w,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class _ItemDestination extends StatelessWidget {
  _ItemDestination({
    super.key,
    required this.nameBusiness,
    required this.typeWate,
    required this.area,
    //required this.totalWeight,
    // required this.phonePartner,
    // required this.namePartner,
    //required this.note,
    required this.isLastItem,
    required this.distanceTime,
    required this.scheduleId,
    required this.controller,
    this.onTap,
  });

  final String nameBusiness,
      typeWate,
      area,
      //totalWeight,
      //phonePartner,
      //namePartner,
      distanceTime;
  //note;
  final bool isLastItem;
  final Function()? onTap;
  final int scheduleId;
  final ScheduleController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.w),
        Obx(() {
          final isStarting = controller.startingStatus[scheduleId]?.value ?? false;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 20.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: isStarting ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        isStarting
                            ? HugeIcons.strokeRoundedStop
                            : HugeIcons.strokeRoundedPlay,
                        size: 5.w,
                        color: Colors.white,
                      ),
                      Text(
                        isStarting ? "Kết thúc" : "Bắt đầu",
                        style: PrimaryFont.bodyTextMedium()
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              isStarting ? MovingGifWidget() : SizedBox(),
            ],
          );
        }),
        SizedBox(height: 5.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50.w,
              child: Text(
                nameBusiness,
                style: PrimaryFont.bodyTextBold().copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 15,
              width: 1,
              color: Colors.grey,
            ),
            Text(
              distanceTime,
              style: PrimaryFont.bodyTextBold().copyWith(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        // Text(
        //   "+BD: $numberBD",
        //   style: PrimaryFont.bodyTextMedium().copyWith(
        //     color: Colors.black,
        //   ),
        // ),
        // Text(
        //   "+CC: $totalWeight",
        //   style: PrimaryFont.bodyTextMedium().copyWith(
        //     color: Colors.black,
        //   ),
        // ),
        SizedBox(height: 1.w),
        Text(
          "Area: $area",
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        SizedBox(height: 1.w),
        Text(
          typeWate,
          style: PrimaryFont.bodyTextMedium().copyWith(
            color: Colors.black,
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       namePartner,
        //       style: PrimaryFont.bodyTextBold().copyWith(
        //         color: Colors.black,
        //       ),
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         if (onTap != null) {
        //           if (kDebugMode) {
        //             print("onTap function is called!");
        //           }
        //           onTap!();
        //         } else {
        //           if (kDebugMode) {
        //             print("onTap is null!");
        //           }
        //         }
        //       },
        //       child: Container(
        //         width: 8.w,
        //         height: 8.w,
        //         decoration: BoxDecoration(
        //           color: kPrimaryColor,
        //           borderRadius: BorderRadius.circular(8.w),
        //         ),
        //         child: Icon(
        //           Icons.call,
        //           color: Colors.white,
        //           size: 4.w,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 1.w),
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
        // if (!isLastItem)
        //   Icon(
        //     Icons.arrow_downward,
        //     color: kPrimaryColor,
        //     size: 5.w,
        //   ),
      ],
    );
  }
}
