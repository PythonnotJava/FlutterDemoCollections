import 'package:flutter/material.dart';

class NeumorphismWrapper extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double intensity;

  const NeumorphismWrapper({
    Key? key,
    required this.child,
    this.borderRadius = 12.0,
    this.blur = 10.0,
    this.intensity = 0.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(intensity)
                : Colors.white.withOpacity(intensity),
            offset: Offset(-blur / 2, -blur / 2),
            blurRadius: blur,
          ),
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withOpacity(intensity)
                : Colors.black.withOpacity(intensity),
            offset: Offset(blur / 2, blur / 2),
            blurRadius: blur,
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: Text('Neumorphism Button Test')),
        body: Center(
          child: NeumorphismWrapper(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Neumorphism Button'),
            ),
          ),
        ),
      ),
    );
  }
}
