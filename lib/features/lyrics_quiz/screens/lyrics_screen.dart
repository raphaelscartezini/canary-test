import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/video_placeholder.dart';
import '../widgets/lyrics_display.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  int _currentLineIndex = 0;

  // Sample French song lyrics
  final List<String> _lyrics = [
    "Bonjour, comment ça va?",
    "Je m'appelle Marie",
    "J'aime la musique",
    "Et danser sous la pluie",
    "",
    "Merci beaucoup mon ami",
    "Pour cette belle journée",
    "S'il vous plaît, restez ici",
    "Nous allons continuer",
    "",
    "La vie est magnifique",
    "Quand on est ensemble",
    "Chaque moment est unique",
    "Et mon cœur se balance",
  ];

  @override
  void initState() {
    super.initState();
    // Simulate lyrics progression every 2 seconds
    _startLyricsAnimation();
  }

  void _startLyricsAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _currentLineIndex < _lyrics.length - 1) {
        setState(() {
          _currentLineIndex++;
        });
        _startLyricsAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final videoHeight = screenHeight * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Lyrics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Video section (60% of screen)
          SizedBox(
            height: videoHeight,
            child: const Padding(
              padding: EdgeInsets.all(AppConstants.spacingM),
              child: VideoPlaceholder(),
            ),
          ),

          // Lyrics section (remaining space)
          Expanded(
            child: LyricsDisplay(
              lyrics: _lyrics,
              currentLineIndex: _currentLineIndex,
            ),
          ),

          // Take Quiz button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: FilledButton(
                onPressed: () => context.go('/quiz'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Take Quiz'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
