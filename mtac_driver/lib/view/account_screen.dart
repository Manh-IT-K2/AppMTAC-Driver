import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mtac_driver/controller/user/login_controller.dart';

class AccountScreen extends StatelessWidget {
   AccountScreen({super.key});
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 232, 232),
      body: Center(
        child: GestureDetector(
          onTap: () {
            loginController.logOut();
          },
          child: Text("Account Screen"),
        ),
      ),
    );
  }
}
