import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pull To Refresh Demo',
      home: RefreshDemo(),
    );
  }
}

class RefreshDemo extends StatefulWidget {
  const RefreshDemo({super.key});

  @override
  RefreshDemoState createState() => RefreshDemoState();
}

class RefreshDemoState extends State<RefreshDemo> {
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<String> items = List.generate(20, (i) => "Item (origin) $i");

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      items = List.generate(20, (i) => "Item (origin) $i");
    });
    refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      items.addAll(List.generate(10, (i) => "Item (new) ${items.length + i}"));
    });
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull To Refresh Demo'),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: ClassicFooter(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (context, index) => ListTile(title: Text(items[index])),
          itemCount: items.length,
        ),
      ),
    );
  }
}
