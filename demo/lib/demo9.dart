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
  Color color = Colors.lightBlue[700] as Color;
  Random random = Random(10);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("ProxyWidget Example")),
        body: Center(
          child: CustomProxyWidget(
            color: color,
            child: ElevatedButton(

              onPressed: (){
                setState(() {
                  int v = random.nextInt(9) + 1;
                  color = Colors.lightBlue[v * 100]!;
                });
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

  const CustomProxyWidget({super.key,
    required this.color,
    required super.child,
  });

  @override
  Element createElement() => CustomProxyWidgetElement(this);
}

class CustomProxyWidgetElement extends ProxyElement{
  CustomProxyWidgetElement(super.widget);

  @override
  void notifyClients(covariant ProxyWidget oldWidget) {
    var c = (widget as CustomProxyWidget).color;
    if (c != (oldWidget as CustomProxyWidget).color){
      debugPrint('你改变了颜色 => $c');
    } else{
      debugPrint('保持原色 => $c');
    }
  }

  @override
  Widget build() {
    return Container(
      decoration: BoxDecoration(
        color: (widget as CustomProxyWidget).color,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: (widget as CustomProxyWidget).child,
    );
  }
}