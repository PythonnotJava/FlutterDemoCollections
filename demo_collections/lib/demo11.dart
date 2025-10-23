import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<StatefulWidget> createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage>{
  int c = 0;

  @override
  Widget build(BuildContext context) {

    Text text1 = Text('计数1', style: const TextStyle(fontSize: 16, color: Colors.black),);
    debugPrint("text1 ad == ${identityHashCode(text1)}");

    const text2 = Text('计数2', style: TextStyle(fontSize: 16, color: Colors.lightBlue),);
    debugPrint("text2 ad == ${identityHashCode(text2)}");

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text1,
            text2,
            Text(
              '$c',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            c++;
          });
        },
        child: Text('Add'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: CounterPage(),
  ));
}