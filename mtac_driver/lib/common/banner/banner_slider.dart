import 'package:flutter/material.dart';
import 'package:mtac_driver/theme/color.dart';
import 'package:sizer/sizer.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  final List<String> _images = [
    'assets/image/banner_app.png',
    'assets/image/banner_app.png',
    'assets/image/banner_app.png',
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 100.w,
          height: 15.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(3.w),
                child: Image.asset(
                  _images[index],
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 3.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 1.w),
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? kPrimaryColor
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
