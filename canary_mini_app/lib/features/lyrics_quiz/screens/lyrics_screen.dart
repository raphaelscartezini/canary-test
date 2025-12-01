import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/lyrics_display.dart';
import '../providers/lyrics_provider.dart';

class LyricsScreen extends ConsumerWidget {
  const LyricsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleBack() {
      // Pause the video before navigating back
      final controller = ref.read(videoControllerProvider);
      controller.pause();
      context.go('/');
    }

    void handleTakeQuiz() {
      // Pause the video before going to quiz
      final controller = ref.read(videoControllerProvider);
      controller.pause();
      context.go('/quiz');
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full screen video background
          const VideoPlayerWidget(),

          // Lyrics overlay on bottom half
          Positioned(
            left: 0,
            right: 0,
            bottom: 80, // Above the Take Quiz button (64px + safe area padding)
            top: MediaQuery.of(context).size.height * 0.5,
            child: const LyricsDisplay(),
          ),

          // Take Quiz button at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: FilledButton(
                onPressed: handleTakeQuiz,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 64),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Take Quiz'),
              ),
            ),
          ),

          // Back button overlay (top left)
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingM),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: handleBack,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
