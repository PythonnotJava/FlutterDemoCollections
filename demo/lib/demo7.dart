import 'package:flutter/material.dart';

class HomeView extends ComponentElement{
  HomeView(super.widget);
  int counter = 0;

  @override
  Widget build() {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            counter++;
            markNeedsBuild();
          },
          child: Text(counter.toString()),
        ),
      ),
    );
  }
}

class CustomHome extends Widget {
  const CustomHome({super.key});

  @override
  Element createElement() {
    return HomeView(this);
  }
}

// main() => runApp(MaterialApp(
//   theme: ThemeData.light(),
//   home: CustomHome(),
//   title: '使用抽象的Element来自定义控件',
// ));