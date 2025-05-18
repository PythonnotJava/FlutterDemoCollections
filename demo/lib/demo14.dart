import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: MaterialApp(
        home: const CounterScreen(),
      ),
    );
  }
}

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("CounterScreen rebuilt");

    return Scaffold(
      appBar: AppBar(title: const Text("Provider + Consumer Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consumer 只包裹这个 Text，所以只有它会重建
            Consumer<CounterProvider>(
              builder: (context, counterProvider, child) {
                debugPrint("Consumer rebuilt");
                return Text(
                  'Count: ${counterProvider.count}',
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 直接调用 Provider 中的方法
                context.read<CounterProvider>().increment();
              },
              child: const Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }
}
