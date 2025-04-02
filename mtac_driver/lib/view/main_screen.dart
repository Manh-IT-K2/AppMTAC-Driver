import 'package:flutter/material.dart';
import 'package:mtac_driver/view/account_screen.dart';
import 'package:mtac_driver/view/home_screen.dart';
import 'package:mtac_driver/view/mailbox_screen.dart';
import 'package:mtac_driver/view/payment_screen.dart';
import 'package:mtac_driver/view/schedule_screen.dart';
import 'package:mtac_driver/widgets/bottom_nav_bar.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;
final PageController _pageController = PageController(initialPage: 2);


 void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  if (_pageController.hasClients) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          ScheduleScreen(),
          PaymentScreen(),
          HomeScreen(),
          MailboxScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
