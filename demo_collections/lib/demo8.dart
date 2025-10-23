import 'package:flutter/material.dart';

class CADBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double step = 20;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // 绘制水平和垂直网格线
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CADBackgroundPainter oldDelegate) => false;
}

class CADForegroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.lightBlue[300]!.withValues(alpha :0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
  @override
  bool shouldRepaint(CADBackgroundPainter oldDelegate) => false;
}

class CADBackground extends StatelessWidget {
  const CADBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: CADBackgroundPainter(),
      foregroundPainter: CADForegroundPainter()
    );
  }
}

// main() => runApp(Scaffold(body: CADBackground(),));