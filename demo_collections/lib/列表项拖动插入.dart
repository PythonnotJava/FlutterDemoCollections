import 'package:flutter/material.dart';

class ReorderDemo extends StatefulWidget {
  @override
  _ReorderDemoState createState() => _ReorderDemoState();
}

class _ReorderDemoState extends State<ReorderDemo> {
  List<String> items = List.generate(10, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ReorderableListView Demo")),
      body: ReorderableListView(
        children: [
          for (int i = 0; i < items.length; i++)
            ListTile(
              key: ValueKey(items[i]),
              title: Text(items[i]),
            )
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            // 调整元素位置
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ReorderDemo()));
