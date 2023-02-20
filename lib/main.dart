import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RotatingAndFlippingCircle(),
    );
  }
}

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
      default:
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockwise);
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide circeSide;

  HalfCircleClipper(this.circeSide);

  @override
  Path getClip(Size size) {
    return circeSide.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class RotatingAndFlippingCircle extends StatefulWidget {
  const RotatingAndFlippingCircle({
    super.key,
  });

  @override
  State<RotatingAndFlippingCircle> createState() =>
      _MyRotatingAndFlippingCircle();
}

class _MyRotatingAndFlippingCircle extends State<RotatingAndFlippingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipPath(
            clipper: HalfCircleClipper(CircleSide.left),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.white,
            ),
          ),
          ClipPath(
            clipper: HalfCircleClipper(CircleSide.right),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.green,
            ),
          )
        ],
      ),
    ));
  }
}
