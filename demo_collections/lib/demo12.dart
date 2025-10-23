import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterApp(),
    );
  }
}

// 1. 定义 InheritedWidget
class CounterProvider extends InheritedWidget {
  const CounterProvider({
    super.key,
    required this.counter,
    required this.increment,
    required super.child,
  });

  final int counter;
  final VoidCallback increment;

  // 这是一个静态方法，用于从上下文获取 CounterProvider 的实例
  static CounterProvider? of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType 会注册当前 context 对此 InheritedWidget 的依赖
    // 当 InheritedWidget 更新时，依赖它的 widget 会重建
    final CounterProvider? result = context.dependOnInheritedWidgetOfExactType<CounterProvider>();
    return result;
  }

  // 控制是否应该重建依赖此 InheritedWidget 的子 widget
  // 只有当 shouldUpdate 返回 true 时，依赖的子 widget 才会重建
  @override
  bool updateShouldNotify(CounterProvider oldWidget) {
    return counter != oldWidget.counter; // 当计数器值改变时才通知更新
  }
}

// 2. StateFullWidget 来管理计数器状态并包裹 InheritedWidget
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      counter: _counter,
      increment: _incrementCounter,
      child: Builder(
        builder: (builderContext) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('InheritedWidget 示例'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '您已经点击了这么多次:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const CurrentCounterDisplay(),
                  const SizedBox(height: 50),
                  const DeeplyNestedWidget(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                CounterProvider.of(builderContext)?.increment();
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

// 3. 子 widget，直接使用 InheritedWidget 提供的数据
class CurrentCounterDisplay extends StatelessWidget {
  const CurrentCounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    // 通过 CounterProvider.of(context) 获取计数器值
    final counter = CounterProvider.of(context)?.counter;
    return Text(
      '$counter',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

// 4. 更深层的子 widget，同样可以访问到数据
class DeeplyNestedWidget extends StatelessWidget {
  const DeeplyNestedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 再次通过 CounterProvider.of(context) 获取 increment 方法
    final increment = CounterProvider.of(context)?.increment;
    return Column(
      children: [
        const Text(
          '这是一个深层嵌套的 widget，它也可以访问计数器功能:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        ElevatedButton(
          onPressed: increment, // 直接调用 increment 方法
          child: const Text('从深层 widget 增加计数'),
        ),
      ],
    );
  }
}