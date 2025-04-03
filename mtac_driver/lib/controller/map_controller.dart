import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapDriverController extends GetxController {
  var startLocation = Rx<LatLng>(const LatLng(0, 0));
  var endLocation = Rx<LatLng>(const LatLng(0, 0));
  var currentLocation = Rx<LatLng?>(const LatLng(10.840788160923305, 106.67717449490108)); // Add current location
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final RxList<LatLng> mainPoints = <LatLng>[].obs;
  final RxList<LatLng> optimizedRoute = <LatLng>[].obs;

  // Thêm các RxList mới cho khoảng cách và thời gian
  final RxList<double> distances = <double>[].obs;
  final RxList<double> durations = <double>[].obs;
  final RxDouble totalDistance = 0.0.obs;
  final RxDouble totalDuration = 0.0.obs;

  final List<String> routeAddresses = [
    "404 Đ. Tân Sơn Nhì, Tân Sơn Nhì, Tân Phú, Hồ Chí Minh, Việt Nam",
    "180 Đ. Nguyễn Thị Minh Khai, Phường 6, Quận 3, Hồ Chí Minh 70000, Việt Nam",
    "42 Điện Biên Phủ, Phường 17, Bình Thạnh, Hồ Chí Minh, Việt Nam",
    "234 Phan Xích Long, Phường 7, Phú Nhuận, Hồ Chí Minh, Việt Nam",
  ];

  @override
  void onInit() {
    super.onInit();
    //getCurrentLocation(); // Get current location first
    //getRoute();
    getOptimizedRoute();
  }

// Thêm MapController
  final MapController mapController = MapController();

  // Hàm di chuyển camera đến vị trí
  void moveToCurrentLocation() {
    if (currentLocation.value != null) {
      mapController.move(currentLocation.value!, 15.0); // 15 là zoom level
      print("📌 Đã di chuyển camera đến vị trí hiện tại");
    }
  }

  Future<void> getCurrentLocation() async {
    print("📍 Getting current location...");
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("⚠️ Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("⚠️ Location permissions are denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("⚠️ Location permissions are permanently denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      currentLocation.value = LatLng(position.latitude, position.longitude);
      print("✅ Current location: ${currentLocation.value}");

      // Tự động di chuyển camera khi có vị trí mới
      moveToCurrentLocation();
    } catch (e) {
      print("⚠️ Error getting current location: $e");
    }
  }

  Future<List<LatLng>> getCoordinates() async {
    mainPoints.clear();
    List<LatLng> results = [];
    for (var address in routeAddresses) {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&addressdetails=1&limit=1");
      try {
        final response = await http.get(url,
            headers: {"User-Agent": "YourAppName/1.0 (your@email.com)"});
        if (response.statusCode == 200) {
          final List data = json.decode(response.body);
          if (data.isNotEmpty) {
            final lat = double.tryParse(data[0]["lat"]) ?? 0;
            final lon = double.tryParse(data[0]["lon"]) ?? 0;
            if (lat != 0 && lon != 0) {
              LatLng point = LatLng(lat, lon);
              results.add(point);
              mainPoints.add(point);
              print("✅ Đã lấy tọa độ chính xác cho '$address': $lat, $lon");
              continue;
            }
          }
        }
        print("⚠️ Không lấy được tọa độ cho '$address'");
      } catch (e) {
        print("⚠️ Lỗi khi lấy tọa độ cho '$address': $e");
      }
    }
    return results;
  }

  // Hàm tính khoảng cách giữa 2 điểm (đơn giản bằng Euclidean distance)
  double calculateDistance(LatLng point1, LatLng point2) {
    const Distance distance = Distance();
    return distance(point1, point2) / 1000; // Trả về km
  }

  // Thuật toán tham lam để tối ưu tuyến đường
  List<LatLng> greedyTSP(LatLng start, List<LatLng> points, LatLng end) {
    List<LatLng> result = [];
    List<LatLng> unvisited = List.from(points);

    // Bắt đầu từ vị trí hiện tại
    LatLng current = start;
    result.add(current);

    while (unvisited.isNotEmpty) {
      // Tìm điểm gần nhất trong các điểm chưa thăm
      int nearestIndex = 0;
      double nearestDistance = calculateDistance(current, unvisited[0]);

      for (int i = 1; i < unvisited.length; i++) {
        double dist = calculateDistance(current, unvisited[i]);
        if (dist < nearestDistance) {
          nearestDistance = dist;
          nearestIndex = i;
        }
      }

      // Di chuyển đến điểm gần nhất
      current = unvisited[nearestIndex];
      result.add(current);
      unvisited.removeAt(nearestIndex);
    }

    // Thêm điểm cuối cùng
    result.add(end);

    return result;
  }

  Future<void> getOptimizedRoute() async {
    print("🔄 Đang tối ưu hóa tuyến đường...");

    // Lấy tọa độ từ địa chỉ
    List<LatLng> waypoints = await getCoordinates();
    if (waypoints.isEmpty) {
      print("⚠️ Không lấy được tọa độ từ địa chỉ!");
      return;
    }

    // Xác định điểm bắt đầu và kết thúc
    startLocation.value = currentLocation.value ?? waypoints.first;
    endLocation.value = waypoints.last;

    // Các điểm trung gian (loại bỏ điểm cuối cùng)
    List<LatLng> intermediatePoints =
        waypoints.sublist(0, waypoints.length - 1);

    // Áp dụng thuật toán tham lam
    List<LatLng> optimizedOrder =
        greedyTSP(startLocation.value, intermediatePoints, endLocation.value);

    print(
        "🔀 Thứ tự tối ưu: ${optimizedOrder.map((p) => "${p.latitude},${p.longitude}").join(" → ")}");

    // Lấy tuyến đường từ OSRM
    await fetchRouteFromOSRM(optimizedOrder);
  }

// Thêm hàm fitAllPoints vào MMapController
  void fitAllPoints() {
    if (optimizedRoute.isEmpty && currentLocation.value == null) return;

    // Tạo danh sách tất cả các điểm cần hiển thị
    List<LatLng> allPoints = [];

    if (currentLocation.value != null) {
      allPoints.add(currentLocation.value!);
    }

    allPoints.addAll(optimizedRoute);
    allPoints.addAll(routePoints);

    if (allPoints.isEmpty) return;

    // Tính toán bounds bao phủ tất cả điểm
    final bounds = LatLngBounds.fromPoints(allPoints);

    // Thêm padding để các điểm không nằm sát mép màn hình

    // Điều chỉnh camera để hiển thụ toàn bộ
    mapController.fitCamera(CameraFit.bounds(
        bounds: bounds, padding: const EdgeInsets.all(50), maxZoom: 16.0));

    print("🗺️ Đã điều chỉnh bản đồ hiển thụ toàn bộ ${allPoints.length} điểm");
  }

  Future<void> fetchRouteFromOSRM(List<LatLng> points) async {
    String waypointsString = points
        .map((latLng) => "${latLng.longitude},${latLng.latitude}")
        .join(";");

    final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/$waypointsString?overview=full&geometries=geojson");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final coordinates = route['geometry']['coordinates'];

          // Cập nhật tuyến đường
          routePoints.clear();
          for (var coord in coordinates) {
            routePoints.add(LatLng(coord[1], coord[0]));
          }

          // Lấy thông tin khoảng cách và thời gian
          extractDistanceAndDuration(route['legs'], points);

          // Lưu lại thứ tự các điểm đã tối ưu
          optimizedRoute.assignAll(points);

          print("✅ Đã cập nhật tuyến đường tối ưu");
          moveToCurrentLocation();
        }
        await Future.delayed(Duration(milliseconds: 300)); // Đợi map render
        fitAllPoints();
      }
    } catch (e) {
      print("⚠️ Lỗi khi lấy tuyến đường: $e");
    }
  }

  void extractDistanceAndDuration(List<dynamic> legs, List<LatLng> points) {
    distances.clear();
    durations.clear();
    totalDistance.value = 0;
    totalDuration.value = 0;

    for (var leg in legs) {
      double distance = (leg['distance'] as num).toDouble(); // mét
      double duration = (leg['duration'] as num).toDouble(); // giây

      distances.add(distance);
      durations.add(duration);

      totalDistance.value += distance;
      totalDuration.value += duration;
    }

    print(
        "📊 Khoảng cách các chặng: ${distances.map((d) => (d / 1000).toStringAsFixed(2) + 'km')}");
    print(
        "⏱️ Thời gian các chặng: ${durations.map((d) => (d / 60).toStringAsFixed(2) + ' phút')}");
    print(
        "📏 Tổng khoảng cách: ${(totalDistance.value / 1000).toStringAsFixed(2)} km");
    print(
        "⏳ Tổng thời gian: ${(totalDuration.value / 60).toStringAsFixed(2)} phút");
  }

  // Hàm định dạng thời gian
  String formatDuration(double seconds) {
    int minutes = (seconds / 60).round();
    if (minutes < 60) {
      return '$minutes phút';
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      return '${hours}h${remainingMinutes}p';
    }
  }
  // Hàm định dạng khoảng cách
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
  }
}
