import 'package:flutter/material.dart';

class MailboxScreen extends StatelessWidget {
  const MailboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return const Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 232, 232),
      body: Center(
        child: Text("Mailbox"),
      ),
    );
  }
}