import 'package:flutter/material.dart';

void main() {
  runApp(NotebookApp());
}

class NotebookApp extends StatelessWidget {
  const NotebookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes Editor')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Start typing your note here...',
          ),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
