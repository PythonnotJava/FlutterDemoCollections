import 'dart:math';
import 'package:flutter/material.dart';

class DragSpawnDemo extends StatefulWidget {
  const DragSpawnDemo({super.key});

  @override
  State<DragSpawnDemo> createState() => _DragSpawnDemoState();
}

class _DragSpawnDemoState extends State<DragSpawnDemo> {
  bool _isDragging = false;
  bool _isAccepted = false;

  // 存放生成的卡片
  final List<_CardData> _cards = [];

  // 框的位置（这里放在底部中间）
  final Offset _targetPosition = const Offset(120, 500);

  // 生成随机颜色
  Color _randomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
    );
  }

  void _addCard() {
    setState(() {
      _cards.add(
        _CardData(
          color: _randomColor(),
          position: const Offset(100, 150), // 初始位置
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("点击生成拖拽卡片")),
      body: Stack(
        children: [
          // 已生成的卡片
          ..._cards.map((card) {
            return Positioned(
              left: card.position.dx,
              top: card.position.dy,
              child: LongPressDraggable<_CardData>(
                data: card,
                onDragStarted: () {
                  setState(() {
                    _isDragging = true;
                    _isAccepted = false; // 每次拖动前重置
                  });
                },
                onDragEnd: (details) {
                  // 如果没放进目标框，隐藏框
                  if (!_isAccepted) {
                    setState(() => _isDragging = false);
                  }
                },
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildCard(card.color, "拖动中"),
                ),
                childWhenDragging: _buildCard(Colors.grey, "原位空"),
                child: _buildCard(card.color, "卡片"),
              ),
            );
          }),

          // 拖拽时才显示目标框
          if (_isDragging || _isAccepted)
            Positioned(
              left: _targetPosition.dx,
              top: _targetPosition.dy,
              child: DragTarget<_CardData>(
                onAccept: (data) {
                  setState(() {
                    _isAccepted = true;
                    _isDragging = false;

                    // 卡片放入框内：更新位置到框的中心
                    data.position = _targetPosition + const Offset(50, 25);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 200,
                    height: 150,
                    child: CustomPaint(
                      painter: _DashedBorderPainter(),
                      child: Center(
                        child: _isAccepted
                            ? _buildCard(Colors.orange, "成功放入")
                            : const Text("把卡片拖进来"),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(Color color, String text) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

/// 保存卡片信息
class _CardData {
  _CardData({required this.color, required this.position});
  Color color;
  Offset position;
}

/// 虚线框绘制器
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final segment = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DragSpawnDemo(),
  ));
}
