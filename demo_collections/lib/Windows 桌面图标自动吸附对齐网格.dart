import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DesktopGrid(),
  ));
}

class DesktopGrid extends StatefulWidget {
  const DesktopGrid({super.key});

  @override
  State<DesktopGrid> createState() => _DesktopGridState();
}

class _DesktopGridState extends State<DesktopGrid> {
  static const int columns = 12; // 网格列数
  static const int rows = 6; // 网格行数
  late double gridWidth;
  late double gridHeight;

  List<IconItem> icons = [];
  int? draggingIndex;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPositions();
  }

  Future<void> _loadPositions() async {
    prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('desktop_icons');
    if (saved != null) {
      final data = jsonDecode(saved) as List;
      icons = data.map((e) => IconItem.fromJson(e)).toList();
    } else {
      icons = [
        IconItem(col: 0, row: 0, label: '我的电脑'),
        IconItem(col: 1, row: 0, label: '回收站'),
        IconItem(col: 0, row: 1, label: '控制面板'),
      ];
    }
    setState(() {});
  }

  Future<void> _savePositions() async {
    await prefs.setString(
      'desktop_icons',
      jsonEncode(icons.map((e) => e.toJson()).toList()),
    );
  }

  bool _isOccupied(int col, int row, int current) {
    for (int i = 0; i < icons.length; i++) {
      if (i == current) continue;
      if (icons[i].col == col && icons[i].row == row) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    gridWidth = size.width / columns;
    gridHeight = size.height / rows;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ne.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: GridPainter(columns, rows)),
            ...List.generate(icons.length, (i) {
              final item = icons[i];
              final pos = Offset(item.col * gridWidth, item.row * gridHeight);

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                left: pos.dx,
                top: pos.dy,
                child: GestureDetector(
                  onPanStart: (_) {
                    draggingIndex = i;
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      final newDx = pos.dx + details.delta.dx;
                      final newDy = pos.dy + details.delta.dy;

                      // 计算实时网格位置（预览用）
                      item.previewCol = (newDx / gridWidth).clamp(0, columns - 1).round();
                      item.previewRow = (newDy / gridHeight).clamp(0, rows - 1).round();
                    });
                  },
                  onPanEnd: (_) {
                    setState(() {
                      final col = item.previewCol ?? item.col;
                      final row = item.previewRow ?? item.row;
                      // 如果目标位置被占用，则还原原位置
                      if (_isOccupied(col, row, i)) {
                        item.previewCol = item.col;
                        item.previewRow = item.row;
                      } else {
                        item.col = col;
                        item.row = row;
                      }
                      draggingIndex = null;
                      _savePositions();
                    });
                  },
                  child: Opacity(
                    opacity: draggingIndex == i ? 0.7 : 1.0,
                    child: Column(
                      children: [
                        const Icon(Icons.folder, color: Colors.white, size: 48),
                        Text(item.label,
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class IconItem {
  int col;
  int row;
  int? previewCol;
  int? previewRow;
  final String label;

  IconItem({required this.col, required this.row, required this.label});

  Map<String, dynamic> toJson() =>
      {'col': col, 'row': row, 'label': label};

  factory IconItem.fromJson(Map<String, dynamic> json) {
    // ✅ 兼容旧版结构（x/y）和新版结构（col/row）
    if (json.containsKey('col') && json.containsKey('row')) {
      return IconItem(
        col: json['col'] ?? 0,
        row: json['row'] ?? 0,
        label: json['label'] ?? '',
      );
    } else if (json.containsKey('x') && json.containsKey('y')) {
      // 把旧版的像素坐标转换成网格坐标
      final double x = json['x']?.toDouble() ?? 0;
      final double y = json['y']?.toDouble() ?? 0;
      return IconItem(
        col: (x / 100).round(), // 假设旧网格间距100
        row: (y / 100).round(),
        label: json['label'] ?? '',
      );
    } else {
      return IconItem(col: 0, row: 0, label: json['label'] ?? '');
    }
  }
}

class GridPainter extends CustomPainter {
  final int columns;
  final int rows;

  GridPainter(this.columns, this.rows);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    final w = size.width / columns;
    final h = size.height / rows;

    for (int i = 0; i <= columns; i++) {
      canvas.drawLine(Offset(i * w, 0), Offset(i * w, size.height), paint);
    }
    for (int j = 0; j <= rows; j++) {
      canvas.drawLine(Offset(0, j * h), Offset(size.width, j * h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
