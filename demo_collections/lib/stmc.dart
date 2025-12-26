import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await SMTCWindows.initialize();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late final AudioPlayer player;
  SMTCWindows? smtc;

  final List<PlaylistItem> playlist = [
    PlaylistItem(
      title: 'Creative Minds',
      artist: 'Bensound',
      url: 'https://www.bensound.com/bensound-music/bensound-creativeminds.mp3',
      thumbnail: 'https://www.bensound.com/bensound-img/creativeminds.jpg',
    ),
    PlaylistItem(
      title: 'Acoustic Breeze',
      artist: 'Bensound',
      url: 'https://www.bensound.com/bensound-music/bensound-acousticbreeze.mp3',
      thumbnail: 'https://www.bensound.com/bensound-img/acousticbreeze.jpg',
    ),
    PlaylistItem(
      title: 'Sunny',
      artist: 'Bensound',
      url: 'https://www.bensound.com/bensound-music/bensound-sunny.mp3',
      thumbnail: 'https://www.bensound.com/bensound-img/sunny.jpg',
    ),
  ];

  int currentIndex = 0;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    if (Platform.isWindows) {
      _initializeSMTC();
    }

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
      if (Platform.isWindows && smtc != null) {
        smtc!.setPlaybackStatus(
          state == PlayerState.playing
              ? PlaybackStatus.playing
              : PlaybackStatus.paused,
        );
      }
    });

    player.onPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
      if (Platform.isWindows && smtc != null && duration.inMilliseconds > 0) {
        smtc!.updateTimeline(
          PlaybackTimeline(
            startTimeMs: 0,
            endTimeMs: duration.inMilliseconds,
            positionMs: pos.inMilliseconds,
            minSeekTimeMs: 0,
            maxSeekTimeMs: duration.inMilliseconds,
          ),
        );
      }
    });

    player.onDurationChanged.listen((dur) {
      setState(() {
        duration = dur;
      });
    });

    player.onPlayerComplete.listen((_) {
      playNext();
    });

    _playAtIndex(0);
  }

  void _initializeSMTC() {
    final current = playlist[currentIndex];
    smtc = SMTCWindows(
      metadata: MusicMetadata(
        title: current.title,
        artist: current.artist,
        thumbnail: current.thumbnail,
      ),
      timeline: const PlaybackTimeline(
        startTimeMs: 0,
        endTimeMs: 0,
        positionMs: 0,
        minSeekTimeMs: 0,
        maxSeekTimeMs: 0,
      ),
    );

    smtc!.buttonPressStream.listen((event) {
      switch (event) {
        case PressedButton.play:
          player.resume();
          break;
        case PressedButton.pause:
          player.pause();
          break;
        case PressedButton.next:
          playNext();
          break;
        case PressedButton.previous:
          playPrevious();
          break;
        case PressedButton.stop:
          player.stop();
          break;
        default:
          break;
      }
    });
  }

  Future<void> _playAtIndex(int index) async {
    if (index < 0 || index >= playlist.length) return;

    setState(() {
      currentIndex = index;
      position = Duration.zero;
    });

    final item = playlist[index];
    await player.play(UrlSource(item.url));

    if (Platform.isWindows && smtc != null) {
      smtc!.updateMetadata(
        MusicMetadata(
          title: item.title,
          artist: item.artist,
          thumbnail: item.thumbnail,
        ),
      );
    }
  }

  void playNext() {
    _playAtIndex((currentIndex + 1) % playlist.length);
  }

  void playPrevious() {
    _playAtIndex((currentIndex - 1 + playlist.length) % playlist.length);
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    player.dispose();
    smtc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = playlist[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Music Player'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              // 专辑封面
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  constraints: const BoxConstraints(maxHeight: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      current.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.music_note, size: 80),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // 播放信息和控制
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        current.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        current.artist,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 进度条
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: position.inMilliseconds.toDouble().clamp(
                              0.0,
                              duration.inMilliseconds.toDouble(),
                            ),
                            max: duration.inMilliseconds.toDouble() > 0
                                ? duration.inMilliseconds.toDouble()
                                : 1.0,
                            onChanged: (value) {
                              player.seek(Duration(milliseconds: value.toInt()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 播放控制按钮
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            iconSize: 40,
                            onPressed: playPrevious,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 20),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              iconSize: 40,
                              onPressed: togglePlayPause,
                            ),
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            iconSize: 40,
                            onPressed: playNext,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 播放列表
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'Playlist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Divider(height: 16),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlist.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final item = playlist[index];
                            final isCurrentlyPlaying = index == currentIndex;

                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item.thumbnail,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 45,
                                      height: 45,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.music_note, size: 20),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isCurrentlyPlaying
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isCurrentlyPlaying
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                item.artist,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: isCurrentlyPlaying
                                  ? const Icon(Icons.volume_up, color: Colors.blue, size: 20)
                                  : null,
                              onTap: () => _playAtIndex(index),
                            );
                          },
                        ),
                      ),
                    ],
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

class PlaylistItem {
  final String title;
  final String artist;
  final String url;
  final String thumbnail;

  PlaylistItem({
    required this.title,
    required this.artist,
    required this.url,
    required this.thumbnail,
  });
}