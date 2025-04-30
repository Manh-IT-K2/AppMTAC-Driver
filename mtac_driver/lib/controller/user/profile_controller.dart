import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/model/user_model.dart';
import 'package:mtac_driver/service/user/user_service.dart';

class ProfileController extends GetxController {
  //
  final Rxn<UserModel> infoUser = Rxn<UserModel>();
  // init
  @override
  void onInit() {
    super.onInit();
    getInforUser();
  }

  // get user from service
  Future<void> getInforUser() async {
    try {
      final user = await UserService().getUser();
      infoUser.value = user;
      print(user);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
    }
  }
}
