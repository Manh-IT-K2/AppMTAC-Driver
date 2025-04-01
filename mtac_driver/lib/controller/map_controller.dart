import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:http/http.dart' as http;

class MapController extends GetxController {

  /* Bottom bar Destination */
  var sheetHeight = 0.07.obs;

  void updateHeight(double delta, double screenHeight) {
    sheetHeight.value -= delta / screenHeight;
    sheetHeight.value = sheetHeight.value.clamp(0.07, 0.7);
  }

  /* Google Map */
  GoogleMapController? mapController;
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);

  // Coordinates of start and end points
  final LatLng startLocation = const LatLng(10.7769, 106.7009);
  final LatLng endLocation = const LatLng(10.8039, 106.7143);

// List of routes points
  final List<LatLng> routePoints = const [
    LatLng(10.7769, 106.7009), // Bến Thành
    LatLng(10.7845, 106.7070), // Nguyễn Thị Minh Khai
    LatLng(10.7932, 106.7112), // Điện Biên Phủ
    LatLng(10.8039, 106.7143), // Bình Thạnh
  ];

  // final List<String> routeNames = const [
  //   "Chợ Bến Thành",
  //   "Nguyễn Thị Minh Khai",
  //   "Điện Biên Phủ",
  //   "Bình Thạnh"
  // ];

  // List Marker
  RxSet<Marker> markers = <Marker>{}.obs;

  // Route list (Polyline)
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  // Save location selected route
  Rx<LatLng?> selectedRoute = Rx<LatLng?>(null);
  // Adress display frame
  RxString selectedAddress = "".obs;
  // Check selected route
  RxBool isRouteSelected = false.obs;

  // Function selected route
  void selectRoute(LatLng position, String address) {
    selectedRoute.value = position;
    selectedAddress.value = address;
    isRouteSelected.value = true;
  }

  // Clear route selected
  void clearSelection() {
    isRouteSelected.value = false;
  }

  // Function open google map on the phone
  void openGoogleMaps() async {
    if (selectedRoute.value != null) {
      final lat = selectedRoute.value!.latitude;
      final lng = selectedRoute.value!.longitude;
      final url = Uri.parse(
          "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving");

      if (await canLaunchUrl(url)) {
        // open google map
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (kDebugMode) {
          print("Không thể mở Google Maps");
        }
      }
    }
  }

  // Lifecycle method of GetX
  @override
  void onInit() {
    super.onInit();
    _loadMapData();
    //getCurrentLocation();
  }

// Future<String> getAddressFromGoogleMaps(LatLng position) async {
//   const String apiKey = "AIzaSyBUjmpm28Qw1FSnxp5eev73WxMDPl5ApY8";
//   final String url =
//       "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     if (data["status"] == "OK") {
//       return data["results"][0]["formatted_address"];
//     }
//   }
//   return "Không tìm thấy địa chỉ";
// }

  // Get address specifically
  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.subLocality}, ${place.locality}";
        return "Địa chỉ: $address";
      }
    } catch (e) {
      return "Lỗi lấy địa chỉ: $e";
    }
    return "Không tìm thấy địa chỉ";
  }

  // Load map from route
  void _loadMapData() async {
    final markerIcon = await createCustomMarker(
      icon: Icons.location_on_outlined,
      backgroundColor: Colors.green,
      borderColor: Colors.white,
    );

    final markerIcon1 = await createCustomMarker(
      icon: HugeIcons.strokeRoundedPackage03,
      backgroundColor: Colors.blue,
      borderColor: Colors.white,
    );

    final markerIcon2 = await createCustomMarker(
      icon: Icons.location_on_outlined,
      backgroundColor: const Color(0xFFF9C805),
      borderColor: Colors.white,
    );

    // Add Marker
    markers.addAll({
      Marker(
        markerId: const MarkerId("start"),
        position: startLocation,
        icon: markerIcon,
      ),
      Marker(
        markerId: const MarkerId("end"),
        position: endLocation,
        icon: markerIcon1,
      ),
      for (int i = 0; i < routePoints.length; i++)
        Marker(
          markerId: MarkerId("point$i"),
          position: routePoints[i],
          icon: markerIcon2,
          onTap: () async {
            String address = await getAddressFromLatLng(routePoints[i]);
            selectRoute(routePoints[i], address);
          },
        ),
    });

    // Add route (Polyline)
    polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.green,
        width: 5,
        points: routePoints,
      ),
    );
  }

  // Save the GoogleMapController object when the map is initialized.
  void setMapController(GoogleMapController controller) {
    mapController = controller;
    update();
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check sevice location
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    // User denied forever
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLocation.value = LatLng(position.latitude, position.longitude);
    final customIcon = await createCurrentLocationMarker();
    // Add marker current location
    markers.add(
      Marker(
        markerId: const MarkerId("currentLocation"),
        position: currentLocation.value!,
        icon: customIcon,
      ),
    );

    // Update Camera to current location
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation.value!, 15),
      );
    }
  }

  // Draw Icon Map
  Future<BitmapDescriptor> createCustomMarker({
    required IconData icon,
    Color backgroundColor = Colors.amber,
    Color borderColor = Colors.white,
  }) async {
    const double size = 125; // Kích thước tổng của marker
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // 🎨 **Tạo màu vẽ**
    final Paint paintBorder = Paint()..color = borderColor; // Viền
    final Paint paintCircle = Paint()..color = backgroundColor; // Nền
    final Paint paintLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final Paint paintDot = Paint()..color = Colors.black; // Chấm tròn đen

    final double circleRadius = size / 3; // Bán kính hình tròn

    // 📌 **1. Vẽ đường kẻ đen dài hơn**
    final double lineStartY = size - 10;
    final double lineEndY = size - 100;
    canvas.drawLine(
      Offset(size / 2, lineStartY),
      Offset(size / 2, lineEndY),
      paintLine,
    );

    // 📌 **2. Dịch chấm tròn đen xuống dưới**
    final double dotRadius = 6;
    canvas.drawCircle(
      Offset(size / 2, lineStartY + 5),
      dotRadius,
      paintDot,
    );

    // 📌 **3. Vẽ viền trắng**
    canvas.drawCircle(
      const Offset(size / 2, size - 80),
      circleRadius + 5,
      paintBorder,
    );

    // 📌 **4. Vẽ nền màu vàng (có thể thay đổi)**
    canvas.drawCircle(
      const Offset(size / 2, size - 80),
      circleRadius,
      paintCircle,
    );

    // 📌 **5. Vẽ icon vị trí màu trắng**
    final TextPainter textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: circleRadius * 1.2,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size / 2 - textPainter.width / 2,
            size - 80 - textPainter.height / 2));

    // 🖼 **Chuyển hình thành BitmapDescriptor để dùng trong Google Maps**
    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await img.toByteData(format: ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  // draw icon current location
  Future<BitmapDescriptor> createCurrentLocationMarker() async {
    const double size = 120; // Kích thước tổng của marker
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // 🎨 **Tạo màu vẽ**
    final Paint paintBorder = Paint()
      ..color = Colors.purple.shade100; // Viền xanh mờ
    final Paint paintCircle = Paint()
      ..color = Colors.purple.shade700; // Nền xanh đậm
    final Paint paintInnerCircle = Paint()
      ..color = Colors.white; // Vòng tròn trong
    final Paint paintArrow = Paint()..color = Colors.purple.shade900; // Mũi tên

    final double outerCircleRadius = size / 2; // Bán kính hình tròn lớn
    final double innerCircleRadius = outerCircleRadius * 0.8; // Hình tròn nhỏ

    // 📌 **1. Vẽ viền xanh mờ**
    canvas.drawCircle(
      Offset(outerCircleRadius, outerCircleRadius),
      outerCircleRadius,
      paintBorder,
    );

    // 📌 **2. Vẽ nền xanh đậm**
    canvas.drawCircle(
      Offset(outerCircleRadius, outerCircleRadius),
      innerCircleRadius,
      paintCircle,
    );

    // 📌 **3. Vẽ vòng tròn trắng bên trong**
    canvas.drawCircle(
      Offset(outerCircleRadius, outerCircleRadius),
      innerCircleRadius * 0.8,
      paintInnerCircle,
    );

    // 📌 **4. Vẽ mũi tên định hướng**
    Path arrowPath = Path()
      ..moveTo(outerCircleRadius, outerCircleRadius - 30) // Đỉnh mũi tên xa hơn
      ..lineTo(outerCircleRadius - 20,
          outerCircleRadius + 15) // Cánh mũi tên rộng hơn
      ..lineTo(outerCircleRadius, outerCircleRadius) // Gốc mũi tên thấp hơn
      ..lineTo(outerCircleRadius + 20,
          outerCircleRadius + 15) // Cánh còn lại rộng hơn
      ..close();

    canvas.drawPath(arrowPath, paintArrow);

    // 🖼 **Chuyển hình thành BitmapDescriptor**
    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final ByteData? byteData =
        await img.toByteData(format: ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  // Open app call on the phone
  void makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
     if (kDebugMode) {
       print("Lỗi Không thể mở ứng dụng gọi điện");
     }     
    }
  }
}
