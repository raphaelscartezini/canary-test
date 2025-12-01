import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

/// Video controller state notifier to keep it alive across navigation
class VideoControllerNotifier extends StateNotifier<VideoPlayerController?> {
  VideoControllerNotifier() : super(null) {
    _initialize();
  }

  Future<void> _initialize() async {
    final controller = VideoPlayerController.asset('assets/videos/louane.mp4');
    await controller.initialize();
    state = controller;
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

/// Provider that keeps the video controller alive
final videoControllerNotifierProvider =
    StateNotifierProvider<VideoControllerNotifier, VideoPlayerController?>(
  (ref) => VideoControllerNotifier(),
);
