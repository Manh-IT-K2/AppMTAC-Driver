import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MMapController extends GetxController {
  var sheetHeight = 0.07.obs;

  void updateHeight(double delta, double screenHeight) {
    sheetHeight.value -= delta / screenHeight;
    sheetHeight.value = sheetHeight.value.clamp(0.07, 0.7);
  }

  final LatLng startLocation = LatLng(10.79493832997027, 106.62914283723049);
  final LatLng endLocation = LatLng(10.797975011315076, 106.69027732373529);
  final RxList<LatLng> routePoints = <LatLng>[].obs;

  final List<String> routeAddresses = [
    "404 Tân Sơn Nhì, Tân Phú, Hồ Chí Minh, Việt Nam",
    "180 Nguyễn Thị Minh Khai, Quận 3, Hồ Chí Minh, Việt Nam",
    "42 Điện Biên Phủ, Bình Thạnh, Hồ Chí Minh, Việt Nam",
    "234 Phan Xích Long, Phú Nhuận, Hồ Chí Minh, Việt Nam",
  ];

  Future<List<LatLng>> getCoordinates() async {
    List<LatLng> results = [];

    for (var address in routeAddresses) {
      final url = Uri.parse(
          "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json");

      try {
        final response = await http.get(url,
            headers: {"User-Agent": "YourAppName/1.0 (your@email.com)"});

        if (response.statusCode == 200) {
          final List data = json.decode(response.body);
          if (data.isNotEmpty) {
            final lat = double.tryParse(data[0]["lat"]) ?? 0;
            final lon = double.tryParse(data[0]["lon"]) ?? 0;
            if (lat != 0 && lon != 0) {
              results.add(LatLng(lat, lon));
              print("✅ Đã lấy tọa độ cho '$address': $lat, $lon");
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

  Future<void> getRoute() async {
    print("🔄 Bắt đầu lấy tuyến đường...");

    // Lấy tọa độ từ địa chỉ
    List<LatLng> waypoints = await getCoordinates();
    print("📍 Số điểm đã lấy được: ${waypoints.length}");

    if (waypoints.isEmpty) {
      print("⚠️ Không lấy được tọa độ từ địa chỉ!");
      return;
    }

    // Thêm điểm bắt đầu và kết thúc nếu cần
    waypoints.insert(0, startLocation);
    waypoints.add(endLocation);

    // Tạo chuỗi waypoints cho OSRM
    String waypointsString = waypoints
        .map((latLng) => "${latLng.longitude},${latLng.latitude}")
        .join(";");

    print("🔗 Chuỗi waypoints: $waypointsString");

    final url = Uri.parse(
        "https://router.project-osrm.org/route/v1/driving/$waypointsString?overview=full&geometries=geojson");

    try {
      print("🌐 Đang gọi OSRM API...");
      final response = await http.get(url);
      print("📊 Phản hồi từ OSRM: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("📝 Dữ liệu tuyến đường: ${data.toString()}");

        if (data['code'] != 'Ok' || data['routes'].isEmpty) {
          print("⚠️ OSRM trả về lỗi: ${data['code']}");
          return;
        }

        final coordinates =
            data['routes'][0]['geometry']['coordinates'] as List<dynamic>;
        print("📌 Số điểm trong tuyến đường: ${coordinates.length}");

        routePoints.clear();
        for (var coord in coordinates) {
          routePoints.add(LatLng(coord[1], coord[0]));
        }
        routePoints.refresh();
        print("✅ Đã cập nhật tuyến đường với ${routePoints.length} điểm");
      } else {
        print("⚠️ Lỗi OSRM: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("⚠️ Lỗi khi lấy tuyến đường: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRoute();
  }
}
