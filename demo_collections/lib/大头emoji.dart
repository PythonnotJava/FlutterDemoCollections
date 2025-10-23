// lib/main.dart
import 'package:flutter/material.dart';

void main() => runApp(BigHeadEmojiApp());

class BigHeadEmojiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大头 Emoji',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: EmojiGridPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmojiGridPage extends StatelessWidget {
  // 你可以在这里添加/删除 emoji
  final List<String> emojis = const [
    '😀','😃','😄','😁','😆','😅','😂','🤣','😊','😇',
    '🙂','🙃','😉','😌','😍','🥰','😘','😗','😙','😚',
    '😋','😛','😝','😜','🤪','🤨','🧐','🤓','😎','🥸',
    '🤩','😏','😒','😞','😔','😟','😕','🙁','☹️','😣',
    '😖','😫','😩','🥺','😢','😭','😤','😠','😡','🤬',
    '🤯','😳','🥵','🥶','😱','😨','😰','😥','😓','🤗',
    '🤔','🤭','🤫','🤥','😶','😐','😑','🫠','🫡','🫢',
    '🫣','🤲','👏','👋','🤝','👍','👎','✊','🤛','🤜',
    '🤞','✌️','🖐️','🤟','👌','🙏','💪','🫶','💥','💫',
  ];

  @override
  Widget build(BuildContext context) {
    // 使用 GridView 自适应布局：每个网格项最大宽度 110
    return Scaffold(
      appBar: AppBar(
        title: Text('选择一个 emoji'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: emojis.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 110,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final e = emojis[index];
            return EmojiTile(emoji: e);
          },
        ),
      ),
    );
  }
}

class EmojiTile extends StatelessWidget {
  final String emoji;
  const EmojiTile({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FullscreenEmojiPage(emoji: emoji),
              fullscreenDialog: false,
            ),
          );
        },
        child: Center(
          // 使用 Hero 动画：tag 使用 emoji 本身（确保唯一）
          child: Hero(
            tag: 'emojiHero:$emoji',
            // 用 Material 保持文本动画时的字体绘制一致
            child: Material(
              color: Colors.transparent,
              child: Text(
                emoji,
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullscreenEmojiPage extends StatelessWidget {
  final String emoji;
  const FullscreenEmojiPage({required this.emoji});

  @override
  Widget build(BuildContext context) {
    // 点击任意地方返回
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              // 居中显示超大 emoji，使用 FittedBox 保证在不同屏幕/纵横比下均最大化且不裁切
              Center(
                child: Hero(
                  tag: 'emojiHero:$emoji',
                  child: Material(
                    color: Colors.transparent,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        emoji,
                        // 设一个非常大的字体，FittedBox 会按可用空间缩放
                        style: TextStyle(fontSize: 600),
                      ),
                    ),
                  ),
                ),
              ),

              // 右上角一个小的退出提示（可选）
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, size: 16, color: Colors.white70),
                        SizedBox(width: 6),
                        Text('点击任意处返回', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
