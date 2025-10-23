import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 判断是不是子窗口
  if (args.isNotEmpty) {
    final Map<String, dynamic> windowArgs = jsonDecode(args.first);
    runApp(ChildWindow(data: windowArgs));
  } else {
    runApp(const MainApp());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Window Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int counter = 0;

  Future<void> _openNewWindow() async {
    // 创建一个新的窗口
    final window = await DesktopMultiWindow.createWindow(jsonEncode({
      'title': '子窗口',
      'counter': counter,
    }));

    window
      ..setFrame(const Offset(300, 200) & const Size(400, 300))
      ..center()
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主窗口')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('当前计数: $counter'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() => counter++),
              child: const Text('增加计数'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openNewWindow,
              child: const Text('打开子窗口'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChildWindow extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChildWindow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final int counter = data['counter'] ?? 0;
    return MaterialApp(
      title: data['title'] ?? '子窗口',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: Text(data['title'] ?? '子窗口')),
        body: Center(
          child: Text('从主窗口传入的计数值: $counter'),
        ),
      ),
    );
  }
}
