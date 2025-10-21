import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    final controlPoint = Offset(size.width / 2, size.height + 40);
    final endPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}

class WaveShapeDemo extends StatelessWidget {
  const WaveShapeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipPath(
        clipper: WaveClipper(),
        child: Container(
          height: 300,
          color: Colors.blueAccent,
          child: const Center(child: Text('🌊 波浪形', style: TextStyle(color: Colors.white, fontSize: 28))),
        ),
      ),
    );
  }
}


main() => runApp(MaterialApp(home: WaveShapeDemo()));