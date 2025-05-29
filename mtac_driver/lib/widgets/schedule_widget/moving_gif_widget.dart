import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MovingGifWidget extends StatefulWidget {
  const MovingGifWidget({super.key});

  @override
  _MovingGifWidgetState createState() => _MovingGifWidgetState();
}

class _MovingGifWidgetState extends State<MovingGifWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double containerWidth = 180; // tổng chiều rộng
  final double gifWidth = 8.w; // chiều rộng của gif

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // tốc độ di chuyển
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: containerWidth - gifWidth, // trừ bề rộng gif để không ra ngoài
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: containerWidth,
      height: 8.w,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                left: _animation.value,
                child: Image.asset(
                  'assets/image/start_collection.gif',
                  width: gifWidth,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
