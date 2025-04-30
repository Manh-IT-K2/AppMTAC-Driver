import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  var hasConnection = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnection();
    _listenConnection();
  }

  void _checkConnection() async {
    var connectivityResultList = await Connectivity().checkConnectivity();
    if (connectivityResultList.isEmpty ||
        connectivityResultList.first == ConnectivityResult.none) {
      hasConnection.value = false;
    } else {
      hasConnection.value = true;
    }
  }

  void _listenConnection() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> resultList) {
      if (resultList.isEmpty || resultList.first == ConnectivityResult.none) {
        hasConnection.value = false;
      } else {
        hasConnection.value = true;
      }
    });
  }
}
