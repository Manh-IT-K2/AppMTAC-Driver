import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapDriverController extends GetxController {

  // inital variable Map
  var startLocation = Rx<LatLng>(const LatLng(0, 0));
  var endLocation = Rx<LatLng>(const LatLng(0, 0));
  var currentLocation = Rx<LatLng?>(const LatLng(9.91613239469001, 105.87755169181108));
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final RxList<LatLng> mainPoints = <LatLng>[].obs;
  final RxList<LatLng> optimizedRoute = <LatLng>[].obs;
  final RxList<double> distances = <double>[].obs;
  final RxList<double> durations = <double>[].obs;
  final RxDouble totalDistance = 0.0.obs;
  final RxDouble totalDuration = 0.0.obs;
  // initial flutter map
  final MapController mapController = MapController();
  // list route
  final List<String> routeAddresses = [
    "Xuân Hòa, Kế Sách, Sóc Trăng, Việt Nam",
    "Nam Sông Hậu, Kế Sách, Sóc Trăng, Việt Nam",
    "Phụng Hiệp, Hậu Giang, Việt Nam",
    "Phú Tân, Châu Thành, Hậu Giang, Việt Nam",
  ];

  // function initial
  @override
  void onInit() {
    super.onInit();
    //getCurrentLocation();
    //getRoute();
    getOptimizedRoute();
  }

  // move camera to currentLocation
  void moveToCurrentLocation() {
    if (currentLocation.value != null) {
      mapController.move(currentLocation.value!, 15.0);
      if (kDebugMode) {
        print("📌 Đã di chuyển camera đến vị trí hiện tại");
      }
    }
  }

  // get currentLocation
  Future<void> getCurrentLocation() async {
    if (kDebugMode) {
      print("📍 Getting current location...");
    }
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print("⚠️ Location services are disabled");
        }
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print("⚠️ Location permissions are denied");
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print("⚠️ Location permissions are permanently denied");
        }
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentLocation.value = LatLng(position.latitude, position.longitude);
      if (kDebugMode) {
        print("✅ Current location: ${currentLocation.value}");
      }
      // auto move camera new location
      moveToCurrentLocation();
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Error getting current location: $e");
      }
    }
  }

  // Convert address to coordinates
  Future<List<LatLng>> getCoordinates() async {
    mainPoints.clear();
    List<LatLng> results = [];
    for (var address in routeAddresses) {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&addressdetails=1&limit=1");
      try {
        // Send a request to the Nominatim API to convert the address to GPS coordinates.
        final response = await http.get(url,
            headers: {"User-Agent": "YourAppName/1.0 (your@email.com)"});
        if (response.statusCode == 200) {
          final List data = json.decode(response.body);
          if (data.isNotEmpty) {
            final lat = double.tryParse(data[0]["lat"]) ?? 0;
            final lon = double.tryParse(data[0]["lon"]) ?? 0;
            if (lat != 0 && lon != 0) {
              LatLng point = LatLng(lat, lon);
              // save
              results.add(point);
              //save for mainpoints
              mainPoints.add(point);
              if (kDebugMode) {
                print("✅ Đã lấy tọa độ chính xác cho '$address': $lat, $lon");
              }
              continue;
            }
          }
        }
        if (kDebugMode) {
          print("⚠️ Không lấy được tọa độ cho '$address'");
        }
      } catch (e) {
        if (kDebugMode) {
          print("⚠️ Lỗi khi lấy tọa độ cho '$address': $e");
        }
      }
    }
    return results;
  }

  // Use OSRM to calculate the actual distance between two points
  Future<double> calculateRoadDistance(LatLng point1, LatLng point2) async {
    final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/${point1.longitude},${point1.latitude};${point2.longitude},${point2.latitude}?overview=false");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          return data['routes'][0]['distance'].toDouble(); //m
        }
      }
      return 0.0;
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Lỗi tính khoảng cách đường bộ: $e");
      }
      return 0.0;
    }
  }

  // Use greedy algorithm to find shortest route
  Future<List<LatLng>> greedyTSPWithTraffic(LatLng start, List<LatLng> points, LatLng end) async {
    List<LatLng> result = [start];
    List<LatLng> unvisited = List.from(points);
    LatLng current = start;

    // average speed by road type km/h
    final roadSpeeds = {
      'motorway': 80.0, 
      'trunk': 60.0,
      'primary': 50.0,
      'secondary': 40.0,
      'tertiary': 30.0,
      'unclassified': 20.0,
      'residential': 20.0,
    };
    while (unvisited.isNotEmpty) {
      // Find nearest point based on actual travel time
      int bestIndex = 0;
      double bestTime = double.infinity;
      for (int i = 0; i < unvisited.length; i++) {
        // distance
        final distance = await calculateRoadDistance(current, unvisited[i]);
        // speed
        final speed = await estimateRoadSpeed(current, unvisited[i], roadSpeeds);
        final time = distance / (speed * 1000 / 3600); // s
        if (time < bestTime) {
          bestTime = time;
          bestIndex = i;
        }
      }
      current = unvisited[bestIndex];
      result.add(current);
      unvisited.removeAt(bestIndex);
    }
    result.add(end);
    return result;
  }

  // Speed ​​estimation function based on road type
  Future<double> estimateRoadSpeed(
      LatLng p1, LatLng p2, Map<String, double> roadSpeeds) async {
    final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/${p1.longitude},${p1.latitude};${p2.longitude},${p2.latitude}?overview=full&steps=true");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          double totalWeightedSpeed = 0.0;
          double totalDistance = 0.0;

          // Analyze each road segment
          for (var leg in data['routes'][0]['legs']) {
            for (var step in leg['steps']) {
              final distance = step['distance'].toDouble();
              final roadType = step['name'] ?? 'unclassified';
              final speed = roadSpeeds[roadType.toLowerCase()] ?? 30.0;

              totalWeightedSpeed += speed * distance;
              totalDistance += distance;
            }
          }
          return totalDistance > 0 ? totalWeightedSpeed / totalDistance : 30.0;
        }
      }
      // Default value if data cannot
      return 30.0;
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Lỗi ước tính tốc độ đường bộ: $e");
      }
      return 30.0;
    }
  }

  // route optimization with traffic factor
  Future<void> getOptimizedRoute() async {
    if (kDebugMode) {
      print("🔄 Đang tối ưu hóa tuyến đường với yếu tố giao thông...");
    }
    List<LatLng> waypoints = await getCoordinates();
    if (waypoints.isEmpty) {
      if (kDebugMode) {
        print("⚠️ Không lấy được tọa độ từ địa chỉ!");
      }
      return;
    }
    startLocation.value = currentLocation.value ?? waypoints.first;
    endLocation.value = waypoints.last;
    List<LatLng> intermediatePoints =
        waypoints.sublist(0, waypoints.length - 1);

    // Using greedy algorithm
    List<LatLng> optimizedOrder = await greedyTSPWithTraffic(
        startLocation.value, intermediatePoints, endLocation.value);

    if (kDebugMode) {
      print("🔀 Thứ tự tối ưu với giao thông: ${optimizedOrder.map((p) => "${p.latitude},${p.longitude}").join(" → ")}");
    }
    await fetchRouteFromOSRM(optimizedOrder);
  }

  // move camera preview all point
  void fitAllPoints() {
    if (optimizedRoute.isEmpty && currentLocation.value == null) return;
    // create all list need preview
    List<LatLng> allPoints = [];
    if (currentLocation.value != null) {
      allPoints.add(currentLocation.value!);
    }
    allPoints.addAll(optimizedRoute);
    allPoints.addAll(routePoints);
    if (allPoints.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(allPoints);
    // preview all point
    mapController.fitCamera(CameraFit.bounds(
        bounds: bounds, padding: const EdgeInsets.all(50), maxZoom: 16.0));
    if (kDebugMode) {
      print("🗺️ Đã điều chỉnh bản đồ hiển thụ toàn bộ ${allPoints.length} điểm");
    }
  }

  // Get route from OSRM
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

          // update route
          routePoints.clear();
          for (var coord in coordinates) {
            routePoints.add(LatLng(coord[1], coord[0]));
          }
          // get distance and time
          extractDistanceAndDuration(route['legs'], points);
          // Save optimized points
          optimizedRoute.assignAll(points);
          if (kDebugMode) {
            print("✅ Đã cập nhật tuyến đường tối ưu");
          }
          moveToCurrentLocation();
        }
        // await map render
        await Future.delayed(const Duration(milliseconds: 300));
        fitAllPoints();
      }
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Lỗi khi lấy tuyến đường: $e");
      }
    }
  }

  void extractDistanceAndDuration(List<dynamic> legs, List<LatLng> points) {
    distances.clear();
    durations.clear();
    totalDistance.value = 0;
    totalDuration.value = 0;

    for (var leg in legs) {
      double distance = (leg['distance'] as num).toDouble(); // m
      double duration = (leg['duration'] as num).toDouble(); // s
      distances.add(distance);
      durations.add(duration);
      totalDistance.value += distance;
      totalDuration.value += duration;
    }

    if (kDebugMode) {
      print("📊 Khoảng cách các chặng: ${distances.map((d) => (d / 1000).toStringAsFixed(2) + 'km')}");
    }
    if (kDebugMode) {
      print("⏱️ Thời gian các chặng: ${durations.map((d) => (d / 60).toStringAsFixed(2) + ' phút')}");
    }
    if (kDebugMode) {
      print("📏 Tổng khoảng cách: ${(totalDistance.value / 1000).toStringAsFixed(2)} km");
    }
    if (kDebugMode) {
      print("⏳ Tổng thời gian: ${(totalDuration.value / 60).toStringAsFixed(2)} phút");
    }
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
