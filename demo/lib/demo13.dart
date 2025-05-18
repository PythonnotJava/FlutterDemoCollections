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
        home: CounterScreen(),
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
    final counterProvider = Provider.of<CounterProvider>(context);

    debugPrint('CounterProvider instance hashCode: ${identityHashCode(counterProvider)}');

    debugPrint("Rebuild!");
    return Scaffold(
      appBar: AppBar(title: const Text("Provider Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count: ${counterProvider.count}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: counterProvider.increment,
              child: const Text("Increment"),
            ),
          ],
        ),
      ),
    );
  }
}
