import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [Page1(), Page2(), Page3()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: setItems(),
        onTap: (index){
          if (currentIndex != index) {
            currentIndex = index;
            setState(() {});
          }
        },
      ),
    );
  }

  List<BottomNavigationBarItem> setItems(){
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: '主页'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
    ];
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Demo'),
              ),
              backgroundColor: Colors.lightBlue,
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.teal[100 * (index % 9)],
                    child: Text('Grid Item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: Text('List Item $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Container(color: Colors.lightBlue,),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Container(color: Colors.red,),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Container(color: Colors.cyan,),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Container(color: Colors.yellow,),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Container(color: Colors.black,),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: Container(color: Colors.green,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300,
                color: Colors.red,
                alignment: Alignment.center,
                child: const Text(
                  'Container 1 - 红色',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                color: Colors.green,
                alignment: Alignment.center,
                child: const Text(
                  'Container 2 - 绿色',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  'Container 3 - 蓝色',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                color: Colors.orange,
                alignment: Alignment.center,
                child: const Text(
                  'Container 4 - 橙色',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                color: Colors.purple,
                alignment: Alignment.center,
                child: const Text(
                  'Container 5 - 紫色',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// main() => runApp(MaterialApp(
//   theme: ThemeData.light(),
//   title: '页面的整体滚动组装',
//   home: HomePage(),
// ));