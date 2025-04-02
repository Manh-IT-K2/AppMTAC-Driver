import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:mtac_driver/utils/theme_text.dart';
import 'package:sizer/sizer.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      // turn off animation press
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: kBackgroundColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedCalendar04), label: "Lên lịch"),
            BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedClock01), label: "Thanh toán"),
            BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedHome11), label: "Trang chủ"),
            BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedNotification03), label: "Hộp thư"),
            BottomNavigationBarItem(icon: Icon(HugeIcons.strokeRoundedUser), label: "Tài khoản"),
          ],
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          iconSize: 5.w,
          selectedLabelStyle: PrimaryFont.bodyTextMedium().copyWith(color: Colors.grey),
          unselectedLabelStyle: PrimaryFont.bodyTextMedium().copyWith(color: kPrimaryColor),
          enableFeedback: false,
        ),
      ),
    );
  }
}
