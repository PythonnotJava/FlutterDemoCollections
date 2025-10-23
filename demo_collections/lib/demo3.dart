import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' show FilePicker, FilePickerResult;
import 'package:image_picker/image_picker.dart';

class MyApp extends StatefulWidget{
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: [MainPage(), SecondPage()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '1'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '2')
        ],
        onTap: (index){
          if(index != currentIndex){
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final textCtl = TextEditingController();
  String? content;

  @override
  void initState() {
    textCtl.text = '等待导入路径中……';
    super.initState();
  }

  @override
  void dispose() {
    textCtl.dispose();
    super.dispose();
  }

  Future<void> readFileContent() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          textCtl.text = filePath;
          File file = File(filePath);
          String fileContent = await file.readAsString();
          debugPrint("file : $filePath");
          setState(() {
            content = fileContent;
          });
        }
      }
    } catch (e) {
      setState(() {
        content = '文件读取失败：$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任意文件读取示例'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: textCtl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '文件路径',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 2, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(173, 216, 230, 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      content ?? '尚未选择文件',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: readFileContent,
                child: const Text('打开文件'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});
  @override
  State<StatefulWidget> createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage>{
  String? imagePath;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = '等待输入中……';
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // 保持图片质量
    );
    if (image != null) {
      setState(() {
        imagePath = image.path;
        debugPrint("file == $imagePath");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: '文件路径',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(173, 216, 230, 0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: imagePath != null
                    ? Image.file(File(imagePath!), fit: BoxFit.contain)
                    : Center(child: Text("尚未选择图片", style: TextStyle(fontSize: 16))),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: getImage,
                child: Text('选择图片')
            ),
          ],
        ),
      ),
    );
  }
}

// main() => runApp(MaterialApp(
//   theme: ThemeData.light(),
//   title: '文件选择',
//   home: MyApp(),
// ));