import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mtac_driver/data/map_screen/item_destination.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDriverController extends GetxController {
  var statusInputWeight = false.obs;
  // Thêm vào controller
  final RxMap<LatLng, String> weightMarkers = <LatLng, String>{}.obs;

  // Hàm cập nhật khối lượng
  void updateWeight(LatLng position, String weight) {
    weightMarkers[position] = weight;
  }

  //
  var sheetHeight = 0.7.obs;
  void updateHeight(double delta, double screenHeight) {
    sheetHeight.value -= delta / screenHeight;
    sheetHeight.value = sheetHeight.value.clamp(0.08, 0.7);
  }

  // Thêm access token Mapbox của bạn
  final String mapboxAccessToken =
      'pk.eyJ1IjoicW1hbmgiLCJhIjoiY205NWNzcmlhMHZoajJycjBibnR5dW9rbiJ9.VEIUO9PSzCRKncGhIscUMw';
  final String mapboxStyleUrl = 'mapbox://styles/mapbox/streets-v11';
  // inital variable Map
  var startLocation = Rx<LatLng>(const LatLng(0, 0));
  var endLocation = Rx<LatLng>(const LatLng(0, 0));
  var currentLocation =
      Rx<LatLng?>(const LatLng(10.841626348121663, 106.67731436791038));
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
  final List<String> routeAddresses =
      itemDestinationData.map((e) => e.addressBusiness).toList();
  // Thêm các thông số xe tải
  final RxDouble truckMaxHeight = 4.0.obs; // Chiều cao tối đa (m)
  final RxDouble truckMaxWeight = 16.0.obs; // Trọng tải tối đa (tấn)
  final RxDouble truckWidth = 2.5.obs; // Chiều rộng (m)
  final RxBool truckHazardousMaterials = false.obs; // Hàng nguy hiểm

  // function initial
  @override
  void onInit() {
    super.onInit();
    //getCurrentLocation();
    getOptimizedRoute();
    formatTruckInfo();
  }

  // Hàm cập nhật thông số xe tải
  void updateTruckSpecs({
    double? maxHeight,
    double? maxWeight,
    double? width,
    bool? hazardousMaterials,
  }) {
    if (maxHeight != null) truckMaxHeight.value = maxHeight;
    if (maxWeight != null) truckMaxWeight.value = maxWeight;
    if (width != null) truckWidth.value = width;
    if (hazardousMaterials != null)
      truckHazardousMaterials.value = hazardousMaterials;

    if (kDebugMode) {
      print('''
      🚛 Cập nhật thông số xe tải:
      - Chiều cao: ${truckMaxHeight.value}m
      - Trọng tải: ${truckMaxWeight.value}tấn
      - Chiều rộng: ${truckWidth.value}m
      - Hàng nguy hiểm: ${truckHazardousMaterials.value ? 'CÓ' : 'KHÔNG'}
      ''');
    }
  }

  // Hàm lấy thông số dạng Map để gửi API
  Map<String, dynamic> getTruckParams() {
    return {
      'vehicle_width': truckWidth.value,
      'vehicle_height': truckMaxHeight.value,
      'vehicle_weight': truckMaxWeight.value,
      'hazardous_goods': truckHazardousMaterials.value,
    };
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
      //moveToCurrentLocation();
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

    for (int i = 0; i < routeAddresses.length; i++) {
      String address = routeAddresses[i];

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

              // ✅ Gán tọa độ vào itemDestinationData tương ứng
              if (i < itemDestinationData.length) {
                itemDestinationData[i].latitude = lat;
                itemDestinationData[i].longitude = lon;
                // print("📍 Tọa độ mới cho '${itemDestinationData[i].nameBusiness}': "
                //       "${itemDestinationData[i].latitude}, ${itemDestinationData[i].longitude}");
              }

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

  // Thay thế hàm checkTruckRestrictions bằng phiên bản Mapbox
  Future<void> checkTruckRestrictions(List<LatLng> route) async {
    if (route.length < 2) return;

    if (kDebugMode) print("🚛 Đang kiểm tra hạn chế cho xe tải...");

    for (int i = 0; i < route.length - 1; i++) {
      final start = route[i];
      final end = route[i + 1];

      final params = getTruckParams();
      final url = Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/driving-traffic/"
          "${start.longitude},${start.latitude};"
          "${end.longitude},${end.latitude}"
          "?access_token=$mapboxAccessToken"
          "&geometries=geojson"
          "&steps=true"
          "&annotations=distance,duration"
          // "&vehicle_width=${params['vehicle_width']}"
          // "&vehicle_height=${params['vehicle_height']}"
          // "&vehicle_weight=${params['vehicle_weight']}"
          // "&hazardous_materials=${params['hazardous_goods']}"
          );

      try {
        final response =
            await http.get(url).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
            final routeInfo = data['routes'][0];

            // Kiểm tra các cảnh báo trong từng bước
            for (final leg in routeInfo['legs']) {
              for (final step in leg['steps']) {
                if (step['maneuver']['type'] == 'avoidance') {
                  if (kDebugMode)
                    print(
                        "⚠️ Cảnh báo tránh: ${step['maneuver']['instruction']}");
                }
                if (step['mode'] == 'ferry') {
                  if (kDebugMode)
                    print("⛴️ Phà: Cần kiểm tra hạn chế cho xe tải");
                }
                if (step['name']?.toLowerCase().contains('tunnel') == true) {
                  if (kDebugMode) print("🚇 Đường hầm: Kiểm tra chiều cao");
                }
              }
            }
          }
        }
      } catch (e) {
        if (kDebugMode) print("⚠️ Lỗi khi kiểm tra hạn chế: $e");
      }
    }
  }

  // Use OSRM to calculate the actual distance between two points
  Future<double> calculateRoadDistance(LatLng point1, LatLng point2) async {
    final params = getTruckParams();
    final url =
        Uri.parse("https://api.mapbox.com/directions/v5/mapbox/driving-traffic/"
            "${point1.longitude},${point1.latitude};"
            "${point2.longitude},${point2.latitude}"
            "?access_token=$mapboxAccessToken"
            "&geometries=geojson"
            "&annotations=distance"
            // "&vehicle_width=${params['vehicle_width']}"
            // "&vehicle_height=${params['vehicle_height']}"
            // "&vehicle_weight=${params['vehicle_weight']}"
            // "&hazardous_materials=${params['hazardous_goods']}"
            );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          return data['routes'][0]['distance'].toDouble();
        }
      }
      return 0.0;
    } catch (e) {
      if (kDebugMode) print("⚠️ Lỗi tính khoảng cách: $e");
      return 0.0;
    }
  }

  // Use greedy algorithm to find shortest route
  Future<List<LatLng>> greedyTSPWithTraffic(
      LatLng start, List<LatLng> points, LatLng end) async {
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
        final speed =
            await estimateRoadSpeed(current, unvisited[i], roadSpeeds);
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
    // Thay YOUR_MAPBOX_ACCESS_TOKEN bằng token của bạn
    final url = Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/driving-traffic/${p1.longitude},${p1.latitude};${p2.longitude},${p2.latitude}?steps=true&access_token=$mapboxAccessToken");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          double totalWeightedSpeed = 0.0;
          double totalDistance = 0.0;

          // Phân tích từng đoạn đường
          for (var leg in data['routes'][0]['legs']) {
            for (var step in leg['steps']) {
              final distance = step['distance'].toDouble();
              // Mapbox sử dụng 'ref' hoặc 'name' cho tên đường
              final roadName = step['name'] ?? step['ref'] ?? 'unclassified';
              final roadType = _classifyRoadType(step); // Phân loại đường
              final speed = roadSpeeds[roadType.toLowerCase()] ??
                  roadSpeeds[roadName.toLowerCase()] ??
                  30.0;

              totalWeightedSpeed += speed * distance;
              totalDistance += distance;
            }
          }
          return totalDistance > 0 ? totalWeightedSpeed / totalDistance : 30.0;
        }
      }
      // Giá trị mặc định nếu không lấy được dữ liệu
      return 30.0;
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Lỗi ước tính tốc độ đường bộ: $e");
      }
      return 30.0;
    }
  }

// Hàm phân loại loại đường từ step của Mapbox
  String _classifyRoadType(Map<String, dynamic> step) {
    // Mapbox có thể cung cấp thông tin loại đường trong step['mode'] hoặc các trường khác
    final String? mode = step['mode'];
    final String? roadClass = step['class'];

    if (roadClass == 'motorway') return 'motorway';
    if (roadClass == 'primary') return 'primary';
    if (mode == 'driving-traffic') return roadClass ?? 'unclassified';

    return 'unclassified';
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // route optimization with traffic factor
  Future<void> getOptimizedRoute() async {
    if (kDebugMode) {
      print("🔄 Bắt đầu tối ưu hóa tuyến đường cho xe tải...");
      print(formatTruckInfo());
    }

    if (!await checkInternetConnection()) {
      if (kDebugMode) print("⚠️ Không có kết nối Internet");
      return;
    }

    try {
      final waypoints = await getCoordinates();
      if (waypoints.isEmpty) {
        if (kDebugMode) print("⚠️ Không lấy được tọa độ từ địa chỉ");
        return;
      }

      startLocation.value = currentLocation.value ?? waypoints.first;
      endLocation.value = waypoints.last;

      final intermediatePoints = await _sortPointsByRoadDistance(
          startLocation.value, waypoints.sublist(0, waypoints.length - 1));

      if (kDebugMode) {
        print("📍 Thứ tự các điểm dừng đã tối ưu:");
        intermediatePoints.asMap().forEach((i, point) {
          print("${i + 1}. ${point.latitude}, ${point.longitude}");
        });
      }

      final fullRoute = [
        startLocation.value,
        ...intermediatePoints,
        endLocation.value
      ];

      // Sử dụng Mapbox thay vì OSRM
      await fetchRouteFromMapbox(fullRoute);

      await checkTruckRestrictions(optimizedRoute);

      if (kDebugMode) print("✅ Hoàn thành tối ưu hóa tuyến đường");
    } catch (e) {
      if (kDebugMode) print("🔴 Lỗi trong quá trình tối ưu hóa: $e");
    }
  }

// Sắp xếp các điểm theo khoảng cách đường bộ thực tế
  Future<List<LatLng>> _sortPointsByRoadDistance(
      LatLng start, List<LatLng> points) async {
    final distanceMap = <LatLng, double>{};

    // Tính toán khoảng cách đường bộ cho từng điểm
    for (final point in points) {
      try {
        distanceMap[point] = await calculateRoadDistance(start, point);
        if (kDebugMode) {
          print("📐 Khoảng cách từ ${start.latitude},${start.longitude} "
              "đến ${point.latitude},${point.longitude}: ${distanceMap[point]?.toStringAsFixed(0)}m");
        }
      } catch (e) {
        if (kDebugMode) print("⚠️ Lỗi tính khoảng cách: $e");
        distanceMap[point] = double.infinity;
      }
    }

    // Sắp xếp theo khoảng cách tăng dần
    points.sort((a, b) => (distanceMap[a] ?? 0).compareTo(distanceMap[b] ?? 0));

    return points;
  }

  Future<List<LatLng>> sortPointsByDistance(
      LatLng start, List<LatLng> points) async {
    // Tạo map lưu khoảng cách từ start đến từng điểm
    final distanceMap = <LatLng, double>{};

    for (var point in points) {
      distanceMap[point] = await calculateRoadDistance(start, point);
    }

    // Sắp xếp theo khoảng cách tăng dần
    points.sort((a, b) => distanceMap[a]!.compareTo(distanceMap[b]!));

    return points;
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
      print(
          "🗺️ Đã điều chỉnh bản đồ hiển thụ toàn bộ ${allPoints.length} điểm");
    }
  }

  // Get route from Mapbox
  Future<void> fetchRouteFromMapbox(List<LatLng> points) async {
    if (points.length < 2) {
      if (kDebugMode) print("⚠️ Cần ít nhất 2 điểm để tạo tuyến đường");
      return;
    }

    // Chuyển đổi các điểm thành chuỗi coordinates cho Mapbox
    final waypointsString =
        points.map((p) => "${p.longitude},${p.latitude}").join(";");

    // Tạo URL Mapbox Directions API
    final url = Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/driving-traffic/$waypointsString"
        "?geometries=geojson"
        "&access_token=$mapboxAccessToken"
        "&overview=full"
        "&annotations=distance,duration"
        "&steps=true" // Thêm steps=true để có thông tin chi tiết
        );

    if (kDebugMode) print("🌐 Đang gọi Mapbox API: ${url.toString()}");

    final client = http.Client();
    try {
      final response =
          await client.get(url).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) print("✅ Nhận dữ liệu từ Mapbox: ${data.toString()}");

        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            data['routes'].isNotEmpty) {
          final route = data['routes'][0];

          // Cập nhật các điểm tuyến đường
          routePoints.assignAll((route['geometry']['coordinates'] as List)
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList());

          // Cập nhật thông tin khoảng cách và thời gian
          extractMapboxDistanceAndDuration(route['legs'], points);
          optimizedRoute.assignAll(points);

          if (kDebugMode) {
            print("🟢 Tuyến đường đã được tối ưu thành công");
            print(
                "📏 Tổng khoảng cách: ${formatDistance(totalDistance.value)}");
            print("⏱️ Tổng thời gian: ${formatDuration(totalDuration.value)}");
          }

          // Di chuyển bản đồ để hiển thị toàn bộ tuyến đường
          WidgetsBinding.instance.addPostFrameCallback((_) {
            fitAllPoints();
          });
        } else {
          if (kDebugMode)
            print("🔴 Lỗi từ Mapbox: ${data['message'] ?? 'Unknown error'}");
        }
      } else {
        if (kDebugMode) print("🔴 Lỗi HTTP: ${response.statusCode}");
        // Thử fallback với profile driving thông thường nếu driving-traffic không hoạt động
        await fetchDrivingRouteFallback(points);
      }
    } catch (e) {
      if (kDebugMode) print("🔴 Lỗi khi gọi Mapbox API: $e");
    } finally {
      client.close();
    }
  }

  // Hàm trích xuất thông tin từ Mapbox response
  void extractMapboxDistanceAndDuration(
      List<dynamic> legs, List<LatLng> points) {
    distances.clear();
    durations.clear();
    totalDistance.value = 0;
    totalDuration.value = 0;

    for (var leg in legs) {
      double distance = (leg['distance'] as num).toDouble(); // meters
      double duration = (leg['duration'] as num).toDouble(); // seconds
      distances.add(distance);
      durations.add(duration);
      totalDistance.value += distance;
      totalDuration.value += duration;
    }

    if (kDebugMode) {
      print(
          "📊 Khoảng cách các chặng: ${distances.map((d) => (d / 1000).toStringAsFixed(2) + 'km')}");
      print(
          "⏱️ Thời gian các chặng: ${durations.map((d) => (d / 60).toStringAsFixed(2) + ' phút')}");
      print(
          "📏 Tổng khoảng cách: ${(totalDistance.value / 1000).toStringAsFixed(2)} km");
      print(
          "⏳ Tổng thời gian: ${(totalDuration.value / 60).toStringAsFixed(2)} phút");
    }
  }

// Fallback khi truck profile không hoạt động
  Future<void> fetchDrivingRouteFallback(List<LatLng> points) async {
    if (kDebugMode)
      print("🔄 Đang thử sử dụng driving profile thông thường...");

    final waypointsString =
        points.map((p) => "${p.longitude},${p.latitude}").join(";");
    final url = Uri.parse(
        "https://api.mapbox.com/directions/v5/mapbox/driving/$waypointsString"
        "?geometries=geojson"
        "&access_token=$mapboxAccessToken"
        "&overview=full");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 'Ok' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          routePoints.assignAll((route['geometry']['coordinates'] as List)
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList());
          extractMapboxDistanceAndDuration(route['legs'], points);
          optimizedRoute.assignAll(points);

          if (kDebugMode) print("⚠️ Đã sử dụng driving profile thay thế");
        }
      }
    } catch (e) {
      if (kDebugMode) print("🔴 Lỗi fallback: $e");
    }
  }

  //
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
      print(
          "📊 Khoảng cách các chặng: ${distances.map((d) => (d / 1000).toStringAsFixed(2) + 'km')}");
    }
    if (kDebugMode) {
      print(
          "⏱️ Thời gian các chặng: ${durations.map((d) => (d / 60).toStringAsFixed(2) + ' phút')}");
    }
    if (kDebugMode) {
      print(
          "📏 Tổng khoảng cách: ${(totalDistance.value / 1000).toStringAsFixed(2)} km");
    }
    if (kDebugMode) {
      print(
          "⏳ Tổng thời gian: ${(totalDuration.value / 60).toStringAsFixed(2)} phút");
    }

    // Kiểm tra các cảnh báo đặc biệt cho xe tải
    for (var leg in legs) {
      for (var step in leg['steps']) {
        if (step['truck_restrictions'] != null) {
          print("⚠️ Cảnh báo xe tải: ${step['truck_restrictions']}");
        }
        if (step['has_tunnel'] == true) {
          print("🚇 Đoạn đường hầm - Kiểm tra chiều cao");
        }
        if (step['has_bridge'] == true) {
          print("🌉 Đoạn cầu - Kiểm tra tải trọng");
        }
      }
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

  //
  Future<List<LatLng>> findTruckParking(LatLng location) async {
    final url = Uri.parse("https://overpass-api.de/api/interpreter?"
        "[out:json];"
        "nwr[amenity=truck_parking]"
        "around:5000,${location.latitude},${location.longitude};"
        "out center;");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['elements'].map<LatLng>((element) {
        return LatLng(
          element['lat'] ?? element['center']['lat'],
          element['lon'] ?? element['center']['lon'],
        );
      }).toList();
    }
    return [];
  }

  //
  String formatTruckInfo() {
    return '''
  🚛 Thông số xe:
  - Chiều cao: ${truckMaxHeight.value}m
  - Trọng tải: ${truckMaxWeight.value}tấn
  - Chiều rộng: ${truckWidth.value}m
  ${truckHazardousMaterials.value ? '⚠️ Vận chuyển hàng nguy hiểm' : ''}
  ''';
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Không thể mở app gọi điện với số: $phoneNumber';
    }
  }

  bool isSameLocation(LatLng point1, LatLng point2) {
    const epsilon = 0.00001; // Sai số cho phép
    return (point1.latitude - point2.latitude).abs() < epsilon &&
        (point1.longitude - point2.longitude).abs() < epsilon;
  }
}
