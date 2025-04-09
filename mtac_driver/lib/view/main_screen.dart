import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/view/account_screen.dart';
import 'package:mtac_driver/view/home_screen.dart';
import 'package:mtac_driver/view/mailbox_screen.dart';
import 'package:mtac_driver/view/payment_screen.dart';
import 'package:mtac_driver/view/schedule_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Mặc định là Home (FloatingActionButton)
  final PageController _pageController = PageController(initialPage: 2);
  final List<IconData> _icons = [
    HugeIcons.strokeRoundedCalendar04, // Schedule (index 0)
    HugeIcons.strokeRoundedClock01, // Payment (index 1)
    HugeIcons.strokeRoundedNotification03, // Mailbox (index 2)
    HugeIcons.strokeRoundedUser, // Account (index 3)
  ];

  final List<Widget> _screens = [
    ScheduleScreen(), // index 0
    PaymentScreen(), // index 1
    HomeScreen(), // index 2 (Home - FloatingActionButton)
    MailboxScreen(), // index 3
    AccountScreen(), // index 4
  ];

  void _onItemTapped(int navBarIndex) {
    // Chuyển đổi từ navBar index (0-3) sang screen index (0,1,3,4)
    final screenIndex = navBarIndex < 2 ? navBarIndex : navBarIndex + 1;
    setState(() => _selectedIndex = screenIndex);
    _pageController.animateToPage(
      screenIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onHomePressed() {
    setState(() => _selectedIndex = 2);
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 232, 232),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onHomePressed,
        backgroundColor: _selectedIndex == 2 ? kPrimaryColor : Colors.grey,
        foregroundColor: Colors.white,
        tooltip: 'Home',
        elevation: 6,
        shape: const CircleBorder(),
        splashColor: Colors.white54,
        hoverElevation: 8,
        child: const Icon(HugeIcons.strokeRoundedHome11),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _icons,
        activeIndex: _selectedIndex == 2 ? -1 : _getNavBarIndex(_selectedIndex),
        gapLocation: GapLocation.center,

        leftCornerRadius: 50,
        rightCornerRadius: 50,
        onTap: _onItemTapped,
        activeColor: kPrimaryColor,
        inactiveColor: Colors.black,
        iconSize: 24,
        elevation: 8,
        blurEffect: true, // Thêm hiệu ứng blur
        shadow: BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }

  int _getNavBarIndex(int screenIndex) {
    // Chuyển đổi từ screen index (0,1,3,4) sang navBar index (0-3)
    return screenIndex < 2 ? screenIndex : screenIndex - 1;
  }
}
