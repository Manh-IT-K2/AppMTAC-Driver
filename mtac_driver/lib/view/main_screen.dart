import 'package:flutter/material.dart';
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
  int _selectedIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  final List<Widget> _screens = [
    const ScheduleScreen(),
    const PaymentScreen(),
    HomeScreen(),
    const MailboxScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int navBarIndex) {
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

  int _getNavBarIndex(int screenIndex) {
    return screenIndex < 2 ? screenIndex : screenIndex - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onHomePressed,
        shape: const CircleBorder(),
        backgroundColor: _selectedIndex == 2 ? kPrimaryColor : Colors.white,
        child: Icon(
          HugeIcons.strokeRoundedHome11,
          color: _selectedIndex == 2 ? Colors.white : Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 75,
            child: CustomPaint(
              painter: CurvedBottomBarPainter(backgroundColor: Colors.white),
              child: Container(),
            ),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                    icon: HugeIcons.strokeRoundedCalendar04, index: 0),
                _buildNavItem(icon: HugeIcons.strokeRoundedClock01, index: 1),
                const SizedBox(width: 50), // chừa chỗ cho FAB
                _buildNavItem(
                    icon: HugeIcons.strokeRoundedNotification03, index: 3),
                _buildNavItem(icon: HugeIcons.strokeRoundedUser, index: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isActive = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        size: 24,
        color: isActive ? kPrimaryColor : Colors.black,
      ),
      onPressed: () => _onItemTapped(_getNavBarIndex(index)),
    );
  }
}

class CurvedBottomBarPainter extends CustomPainter {
  final Color backgroundColor;

  CurvedBottomBarPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;

    final path = Path();
    path.moveTo(0, 20); // Góc trái hạ xuống 1 chút

    // 🔽 Góc trái vát xuống
    path.quadraticBezierTo(0, 0, 0, 0);

    // ➡️ Đi dốc nhẹ lên hõm
    path.cubicTo(
      size.width * 0.25,
      -20,
      size.width * 0.35,
      -40,
      size.width / 2 - 45,
      -10,
    );

    // 🔽 Hõm nghiêng từ trái sang phải
    path.cubicTo(
      size.width / 2 - 50, 30, // điểm control trái - cao
      size.width / 2 - 30, 40, // điểm control đáy trái
      size.width / 2, 40, // đáy hõm
    );
    path.cubicTo(
      size.width / 2 + 30, 40, // điểm control đáy phải
      size.width / 2 + 50, 30, // điểm control phải - thấp hơn
      size.width / 2 + 45, -10, // kết thúc hõm
    );

    // ➡️ Đi dốc nhẹ xuống
    path.cubicTo(
      size.width * 0.65,
      -30,
      size.width * 0.75,
      -20,
      size.width - 10,
      -1,
    );

    // 🔽 Góc phải vát xuống
    path.quadraticBezierTo(size.width, 0, size.width, 0);

    // ⬇️ Đóng phần dưới
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
