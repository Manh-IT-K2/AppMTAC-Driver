import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MMapController extends GetxController {
  /* Bottom bar Destination */
  var sheetHeight = 0.07.obs;

  void updateHeight(double delta, double screenHeight) {
    sheetHeight.value -= delta / screenHeight;
    sheetHeight.value = sheetHeight.value.clamp(0.07, 0.7);
  }

  // Vị trí mặc định
  final LatLng startLocation = LatLng(10.7769, 106.7009);
  final LatLng endLocation = LatLng(10.8039, 106.7143);
  final List<LatLng> routePoints = <LatLng>[].obs;

  // Danh sách các địa điểm
  final List<String> routeAddresses = [
    "404 Tân Sơn Nhì, Tân Phú, Hồ Chí Minh, Việt Nam",
    "180 Nguyễn Thị Minh Khai, Quận 3, Hồ Chí Minh, Việt Nam",
    "42 Điện Biên Phủ, Bình Thạnh, Hồ Chí Minh, Việt Nam",
    "234 Phan Xích Long, Phú Nhuận, Hồ Chí Minh, Việt Nam",
  ];

  // Hàm lấy danh sách tọa độ từ địa chỉ
  Future<List<LatLng>> getCoordinates() async {
    List<LatLng> locations = [];
    for (String address in routeAddresses) {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]["lat"]);
          final lon = double.parse(data[0]["lon"]);
          locations.add(LatLng(lat, lon));
        }
      }
    }
    return locations;
  }

  // Hàm lấy tuyến đường từ OSRM
  Future<void> getRoute() async {
    List<LatLng> waypoints = await getCoordinates();
    if (waypoints.length < 2) return;

    String waypointsString = waypoints
        .map((latLng) => "${latLng.longitude},${latLng.latitude}")
        .join(";");

    final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/$waypointsString?overview=full&geometries=geojson");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates =
          data['routes'][0]['geometry']['coordinates'] as List<dynamic>;

      routePoints.clear();
      for (var coord in coordinates) {
        routePoints.add(LatLng(coord[1], coord[0]));
      }
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRoute();
  }
}
