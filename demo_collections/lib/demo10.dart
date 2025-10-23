import 'dart:math';
import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(Colors.lightBlue[700]!);
  Random random = Random(10);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("ProxyWidget Example")),
        body: Center(
          child: CustomProxyWidget(
            valueNotifier: colorNotifier,
            color: colorNotifier.value,
            child: ElevatedButton(
              onPressed: (){
                int v = random.nextInt(9) + 1;
                colorNotifier.value = Colors.lightBlue[v * 100]!;
              },
              child: Text('随机lightBlue强度'),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomProxyWidget extends ProxyWidget {
  final Color color;
  final ValueNotifier<Color> valueNotifier;

  const CustomProxyWidget({super.key,
    required this.color,
    required super.child,
    required this.valueNotifier,
  });

  @override
  Element createElement() => CustomProxyWidgetElement(this);
}

class CustomProxyWidgetElement extends ProxyElement{
  CustomProxyWidgetElement(super.widget);

  @override
  void notifyClients(covariant ProxyWidget oldWidget) {
    var c = (widget as CustomProxyWidget).color;
    if (c != (oldWidget as CustomProxyWidget).color) {
      debugPrint('你改变了颜色 => $c');
    } else {
      debugPrint('保持原色 => $c');
    }
  }

  @override
  Widget build() {
    return ValueListenableBuilder<Color>(
      valueListenable: (widget as CustomProxyWidget).valueNotifier,
      builder: (context, color, aa){
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: (widget as CustomProxyWidget).child,
        );
      }
    );
  }
}