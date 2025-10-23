import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: JoystickWorldDemo(),
  ));
}

class JoystickWorldDemo extends StatefulWidget {
  const JoystickWorldDemo({super.key});

  @override
  State<JoystickWorldDemo> createState() => _JoystickWorldDemoState();
}

class _JoystickWorldDemoState extends State<JoystickWorldDemo> {
  Offset player = Offset.zero; // 角色位置
  Offset velocity = Offset.zero; // 移动方向
  double speed = 4.0;

  final Map<Point<int>, Color> worldChunks = {};
  final int chunkSize = 400;

  late Timer timer;

  // ==== 新增 ====
  double zoom = 1.0; // 当前缩放倍数
  Offset viewOffset = Offset.zero; // 手动拖动偏移
  Offset _lastFocalPoint = Offset.zero;
  double _lastZoom = 1.0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 16), (_) => _update());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _update() {
    if (velocity == Offset.zero) return;
    setState(() {
      player += velocity * speed;

      final px = (player.dx / chunkSize).floor();
      final py = (player.dy / chunkSize).floor();

      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          final key = Point(px + i, py + j);
          worldChunks.putIfAbsent(key, () {
            final rnd = Random(px * 73856093 ^ py * 19349663 ^ i * 83492791);
            return Color.fromARGB(
              255,
              100 + rnd.nextInt(155),
              100 + rnd.nextInt(155),
              100 + rnd.nextInt(155),
            );
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // ===== 新增手势控制 =====
        onScaleStart: (details) {
          _lastFocalPoint = details.focalPoint;
          _lastZoom = zoom;
        },
        onScaleUpdate: (details) {
          setState(() {
            // 双指缩放
            zoom = (_lastZoom * details.scale).clamp(0.5, 2.5);
            // 单指拖动
            viewOffset += details.focalPoint - _lastFocalPoint;
            _lastFocalPoint = details.focalPoint;
          });
        },
        child: Stack(
          children: [
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: WorldPainter(
                player: player,
                worldChunks: worldChunks,
                chunkSize: chunkSize,
                zoom: zoom,
                viewOffset: viewOffset,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Joystick(
                  onChanged: (dir) => setState(() => velocity = dir),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '缩放: ${zoom.toStringAsFixed(2)}x',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 绘制整个世界
class WorldPainter extends CustomPainter {
  final Offset player;
  final Map<Point<int>, Color> worldChunks;
  final int chunkSize;
  final double zoom;
  final Offset viewOffset;

  WorldPainter({
    required this.player,
    required this.worldChunks,
    required this.chunkSize,
    required this.zoom,
    required this.viewOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 缩放 + 平移视角
    canvas.translate(center.dx + viewOffset.dx, center.dy + viewOffset.dy);
    canvas.scale(zoom);
    canvas.translate(-player.dx, -player.dy);

    // 绘制世界块
    for (var e in worldChunks.entries) {
      final pos = Offset(e.key.x * chunkSize.toDouble(),
          e.key.y * chunkSize.toDouble());
      final rect =
      Rect.fromLTWH(pos.dx, pos.dy, chunkSize.toDouble(), chunkSize.toDouble());
      final paint = Paint()..color = e.value;
      canvas.drawRect(rect, paint);

      // 格线
      final gridPaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..strokeWidth = 1 / zoom; // 缩放保持线宽
      for (int i = 0; i <= chunkSize; i += 40) {
        canvas.drawLine(
            Offset(pos.dx + i, pos.dy),
            Offset(pos.dx + i, pos.dy + chunkSize),
            gridPaint);
        canvas.drawLine(
            Offset(pos.dx, pos.dy + i),
            Offset(pos.dx + chunkSize, pos.dy + i),
            gridPaint);
      }
    }

    // 绘制角色
    final playerPaint = Paint()..color = Colors.blueAccent;
    canvas.drawCircle(player, 10, playerPaint);
  }

  @override
  bool shouldRepaint(covariant WorldPainter oldDelegate) => true;
}

/// 虚拟摇杆
class Joystick extends StatefulWidget {
  final ValueChanged<Offset> onChanged;
  const Joystick({super.key, required this.onChanged});

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset delta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        final offset = d.localPosition - const Offset(50, 50);
        final len = offset.distance.clamp(0, 40);
        final dir = offset.direction;
        final norm = Offset(cos(dir), sin(dir)) * (len / 40);
        setState(() => delta = norm);
        widget.onChanged(norm);
      },
      onPanEnd: (_) {
        setState(() => delta = Offset.zero);
        widget.onChanged(Offset.zero);
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400, width: 2),
              ),
            ),
            Positioned(
              left: 50 + delta.dx * 30 - 15,
              top: 50 + delta.dy * 30 - 15,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
