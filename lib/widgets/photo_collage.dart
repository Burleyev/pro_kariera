import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro_kariera/widgets/photo.dart';

class PhotoCollage extends StatefulWidget {
  const PhotoCollage({super.key});

  @override
  State<PhotoCollage> createState() => _PhotoCollageState();
}

class _PhotoCollageState extends State<PhotoCollage>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  late final Animation<double> _animation1;
  late final Animation<double> _animation2;
  late final Animation<double> _animation3;

  final List<Timer> _timers = [];

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation1 = CurvedAnimation(parent: _controller1, curve: Curves.easeIn);
    _animation2 = CurvedAnimation(parent: _controller2, curve: Curves.easeIn);
    _animation3 = CurvedAnimation(parent: _controller3, curve: Curves.easeIn);

    // Старт с защитой от dispose()
    _controller1.forward();
    _timers.add(
      Timer(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        _controller2.forward();
      }),
    );
    _timers.add(
      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        _controller3.forward();
      }),
    );
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final maxW = c.maxWidth.isFinite ? c.maxWidth : 800.0;
        final height = math.max(280.0, math.min(520.0, maxW * 0.6));
        final width = maxW;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // фото #3
              Positioned(
                right: 0,
                top: 0,
                child: FadeTransition(
                  opacity: _animation1,
                  child: Photo(asset: 'assets/photo3.jpeg', h: 500.h),
                ),
              ),
              // фото #2
              Positioned(
                right: 270,
                top: height * 0.05,
                child: FadeTransition(
                  opacity: _animation2,
                  child: Photo(asset: 'assets/photo2.jpeg', h: 200.h),
                ),
              ),
              // фото #7
              Positioned(
                right: 220,
                top: height * 0.58,
                child: FadeTransition(
                  opacity: _animation3,
                  child: Photo(asset: 'assets/photo7.jpeg', h: 300.h),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
