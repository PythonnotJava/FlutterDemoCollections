import 'package:flutter/material.dart';

final PageStorageBucket globalPageStorageBucket = PageStorageBucket();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController textController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageStorage 示例')),
      body: SafeArea(
        child: Column(
          children: [
            PageStorage(
              key: const PageStorageKey('editor1'),
              bucket: globalPageStorageBucket,
              child: TextField(
                controller: textController1,
                decoration: const InputDecoration(hintText: '输入文本...'),
                onChanged: (text) {
                  globalPageStorageBucket.writeState(
                    context,
                    text,
                    identifier: 'editor1_text',
                  );
                },
              ),
            ),
            Expanded(
              child: PageStorage(
                key: const PageStorageKey('list'),
                bucket: globalPageStorageBucket,
                child: ListView.builder(
                  key: const PageStorageKey('listView'),
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.access_alarm),
                    title: Text('data ${index + 1}'),
                  ),
                  itemCount: 100,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JumpToPage(),
                    ),
                  );
                },
                child: const Text('跳转界面2')),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    textController1.text = globalPageStorageBucket.readState(
      context,
      identifier: 'editor1_text',
    ) ??
        '';
  }
}

class JumpToPage extends StatelessWidget {
  const JumpToPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('跳转页面')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),  // 不使用pop，特地展示该控件
              ),
            );
          },
          child: const Text('回到界面1'),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  theme: ThemeData.light(),
  title: '基于PageStorage保存控件状态',
  home: HomePage(),
));
