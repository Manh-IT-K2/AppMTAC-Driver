import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/image/no_internet.gif",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
