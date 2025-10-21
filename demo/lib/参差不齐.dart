import 'package:flutter/material.dart';

void main() => runApp(const OffsetSplitApp());

class OffsetSplitApp extends StatelessWidget {
  const OffsetSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '参差左右补齐布局',
      theme: ThemeData.dark(),
      home: const OffsetSplitPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OffsetSplitPage extends StatelessWidget {
  const OffsetSplitPage({super.key});

  @override
  Widget build(BuildContext context) {
    const double blockHeight = 120; // 块高
    const double firstLeftExtra = 80; // 左首块额外高
    const int leftCount = 15;
    const int rightCount = 17;

    // 计算左右总高度
    final totalLeft = (leftCount - 1) * blockHeight + (blockHeight + firstLeftExtra);
    final totalRight = rightCount * blockHeight;

    // 哪边需要补齐
    bool fillLeft = totalLeft < totalRight;
    double diff = (totalRight - totalLeft).abs();

    // 左列块
    final leftBlocks = [
      _mockBlock("L0(高)", Colors.blueAccent.shade400, blockHeight + firstLeftExtra),
      ...List.generate(
        leftCount - 1,
            (i) => _mockBlock("L${i + 1}", Colors.blueGrey.shade400, blockHeight),
      ),
    ];

    // 右列块
    final rightBlocks = List.generate(
      rightCount,
          (i) => _mockBlock("R$i", Colors.tealAccent.shade400, blockHeight),
    );

    // 生成补齐块（仅一块）
    if (diff > 0) {
      final fillBlock = _mockBlock(
        "补齐(一块)",
        Colors.deepOrange.shade400,
        diff,
      );
      if (fillLeft) {
        leftBlocks.add(fillBlock);
      } else {
        rightBlocks.add(fillBlock);
      }
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: leftBlocks),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: rightBlocks),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _mockBlock(String label, Color color, double height) {
    return Container(
      height: height,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
