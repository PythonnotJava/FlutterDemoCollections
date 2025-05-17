import 'package:flutter/material.dart';

class RoutePath {
  static String pathA = 'A';
  static String pathB = 'B';

  static MaterialPageRoute pageRoute(
      Widget widget, {
        RouteSettings? settings,
        bool? fullscreenDialog,
        bool? maintainState,
        bool? allowSnapshotting
      }){
    return MaterialPageRoute(
        builder: (context){
          return widget;
        },
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? false
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name){
      case 'A':
        return pageRoute(PageA(textFromB: (settings.arguments as Map?)?['content'] ?? '没传入'), settings: settings);
      case 'B':
        return pageRoute(PageB(textFromA: (settings.arguments as Map?)?['content'] ?? '没传入'), settings: settings);
      default:
        return pageRoute(Scaffold(
          body: SafeArea(
            child: Center(
              child: Text("路由${settings.name}不存在！"),
            ),
          ),
        )
      );
    }
  }
}

class PageA extends StatefulWidget {
  final String? textFromB;
  const PageA({super.key, this.textFromB});

  @override
  State<StatefulWidget> createState() => PageAState();
}

class PageAState extends State<PageA>{
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = '界面A';
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: textEditingController,),
            Text(widget.textFromB ?? '没传入'),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(
                  context,
                  'B',
                  arguments: {'content' : textEditingController.text}
                );
              },
              child: Text('跳转到B')
            )
          ],
        ),
      ),
    );
  }
}


class PageB extends StatefulWidget {
  final String? textFromA;
  const PageB({super.key, this.textFromA});

  @override
  State<StatefulWidget> createState() => PageBState();
}

class PageBState extends State<PageB>{
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = '界面B';
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: textEditingController,),
            Text(widget.textFromA ?? '没传入'),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(
                  context,
                  'A',
                  arguments: {'content' : textEditingController.text}
                );
              },
              child: Text('跳转回A')
            )
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     theme: ThemeData.light(),
//     title: '路由与传参',
//     initialRoute: RoutePath.pathA,
//     onGenerateRoute: RoutePath.generateRoute,
//   ));
// }