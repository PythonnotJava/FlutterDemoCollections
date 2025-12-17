import 'package:flutter/material.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => MobileAppState();
}

class MobileAppState extends State<MobileApp> {
  Offset viewPosition = const Offset(100, 100);

  final double boxSize = 100;

  @override
  Widget build(BuildContext context) {
    debugPrint("重构");

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ne.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      constraints: const BoxConstraints(minHeight: 600, minWidth: 800),
      child: Stack(
        children: [
          Positioned(
            left: viewPosition.dx,
            top: viewPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                final Offset next = viewPosition + details.delta;

                /// 限制范围：防止超出容器边界
                double newX = next.dx.clamp(0.0, width - boxSize);
                double newY = next.dy.clamp(0.0, height - boxSize);

                setState(() {
                  viewPosition = Offset(newX, newY);
                });
              },
              child: SizedBox(
                width: boxSize,
                height: boxSize,
                child: const ColoredBox(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: MobileApp()),
  ),
);
