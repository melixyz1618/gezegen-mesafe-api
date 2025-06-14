import 'dart:math';
import 'package:flutter/material.dart';

class Starfield extends StatefulWidget {
  const Starfield({super.key});

  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> stars;
  final int numStars = 150;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStars();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..addListener(() {
        setState(() {
          stars = stars.map((star) {
            final newY = (star.dy + 1) % MediaQuery.of(context).size.height;
            return Offset(star.dx, newY);
          }).toList();
        });
      })
      ..repeat();
  }

  void _initializeStars() {
    stars = List.generate(
      numStars,
          (index) => Offset(
        Random().nextDouble() * MediaQuery.of(context).size.width,
        Random().nextDouble() * MediaQuery.of(context).size.height,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarfieldPainter(stars),
      child: Container(),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Offset> stars;

  StarfieldPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);
    for (var star in stars) {
      canvas.drawCircle(star, 1.2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
