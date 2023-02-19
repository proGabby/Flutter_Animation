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
      home: const RotatingBox(title: 'Flutter Demo Home Page'),
    );
  }
}

class RotatingBox extends StatefulWidget {
  const RotatingBox({super.key, required this.title});

  final String title;

  @override
  State<RotatingBox> createState() => _MyRotatingBox();
}

class _MyRotatingBox extends State<RotatingBox>
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
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, childWidget) {
            return Transform(
              // origin: Offset(dx, dy),
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_animation.value),
              child: childWidget,
            );
          },
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3)),
                ]),
          ),
        ),
      ),
    );
  }
}
