import 'package:flutter/material.dart';

class MailboxScreen extends StatelessWidget {
  const MailboxScreen({super.key});
  //Color.fromARGB(255, 234, 232, 232)
  @override
  Widget build(BuildContext context) {
   return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Mailbox"),
      ),
    );
  }
}