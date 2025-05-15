import 'package:flutter/material.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            debugPrint('PointerDown - 手指按下：${event.position}');
          },
          onPointerMove: (event) {
            debugPrint('PointerMove - 手指移动：${event.position}');
          },
          onPointerUp: (event) {
            debugPrint('PointerUp - 手指抬起：${event.position}');
          },
          onPointerHover: (event) {
            debugPrint('PointerHover - 悬停：${event.position}');
          },
          onPointerCancel: (event) {
            debugPrint('PointerCancel - 事件取消');
          },
          onPointerPanZoomStart: (event) {
            debugPrint('PointerPanZoomStart - 平移缩放开始：${event.position}');
          },
          onPointerPanZoomUpdate: (event) {
            debugPrint('PointerPanZoomUpdate - 平移缩放更新：${event.position}');
          },
          onPointerPanZoomEnd: (event) {
            debugPrint('PointerPanZoomEnd - 平移缩放结束：${event.position}');
          },
          onPointerSignal: (event) {
            debugPrint('PointerSignal - 其他信号：$event');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
        ),
      ),
    );
  }
}

main() => runApp(MaterialApp(
  theme: ThemeData.dark(),
  home: MyApp(),
  title: '手势监听',
));