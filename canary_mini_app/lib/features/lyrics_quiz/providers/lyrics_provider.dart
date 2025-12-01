import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../models/lyric_line.dart';
import '../models/word.dart';
import '../../../core/utils/srt_parser.dart';

/// State class for lyrics with word-level highlighting
class LyricsState {
  final List<LyricPhrase> phrases;
  final int currentPhraseIndex;
  final int currentWordIndex; // Index of current word within the phrase
  final bool isLoading;
  final String? error;

  const LyricsState({
    required this.phrases,
    this.currentPhraseIndex = 0,
    this.currentWordIndex = -1, // -1 means no word is active
    this.isLoading = false,
    this.error,
  });

  LyricsState copyWith({
    List<LyricPhrase>? phrases,
    int? currentPhraseIndex,
    int? currentWordIndex,
    bool? isLoading,
    String? error,
  }) {
    return LyricsState(
      phrases: phrases ?? this.phrases,
      currentPhraseIndex: currentPhraseIndex ?? this.currentPhraseIndex,
      currentWordIndex: currentWordIndex ?? this.currentWordIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Lyrics notifier to handle video sync with word-level highlighting
class LyricsNotifier extends StateNotifier<LyricsState> {
  LyricsNotifier()
      : super(const LyricsState(
          phrases: [],
          currentPhraseIndex: 0,
          currentWordIndex: -1, // Start with no word highlighted
          isLoading: true,
        )) {
    _loadLyrics();
  }

  /// Load lyrics from word-level SRT file
  Future<void> _loadLyrics() async {
    try {
      state = state.copyWith(isLoading: true);

      // Load word-level lyrics from SRT file
      final phrases = await SrtParser.loadWordsFromAsset('assets/subtitles/louane.srt');

      state = state.copyWith(
        phrases: phrases,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load lyrics: $e',
      );
    }
  }

  /// Update highlighted phrase and word based on video position
  void updatePosition(Duration position) {
    if (state.phrases.isEmpty) return;

    final seconds = position.inMilliseconds / 1000.0;
    const leadTime = 1.0; // Show lyrics 1 second before they start

    // Find the current phrase (considering lead time)
    int newPhraseIndex = -1; // -1 means no phrase should be shown yet
    for (int i = 0; i < state.phrases.length; i++) {
      final phraseStart = state.phrases[i].startTime - leadTime;
      final phraseEnd = state.phrases[i].endTime;

      if (seconds >= phraseStart && seconds <= phraseEnd) {
        newPhraseIndex = i;
        break;
      } else if (i == state.phrases.length - 1 && seconds > phraseEnd) {
        // After the last phrase
        newPhraseIndex = i;
      }
    }

    // Don't show anything if we're before the first phrase (with lead time)
    if (newPhraseIndex == -1) {
      if (state.currentPhraseIndex != 0 || state.currentWordIndex != -1) {
        state = state.copyWith(
          currentPhraseIndex: 0,
          currentWordIndex: -1,
        );
      }
      return;
    }

    // Find the current word within the phrase
    int newWordIndex = -1; // -1 means no word is active yet (before first word starts)
    if (newPhraseIndex >= 0 && newPhraseIndex < state.phrases.length) {
      final currentPhrase = state.phrases[newPhraseIndex];

      // Check if we're before the first word of the phrase starts
      if (seconds < currentPhrase.words.first.startTime) {
        newWordIndex = -1; // No word highlighted yet
      } else {
        // Find which word is currently being sung
        for (int i = 0; i < currentPhrase.words.length; i++) {
          if (seconds >= currentPhrase.words[i].startTime && seconds <= currentPhrase.words[i].endTime) {
            newWordIndex = i;
            break;
          } else if (seconds < currentPhrase.words[i].startTime) {
            newWordIndex = i > 0 ? i - 1 : -1;
            break;
          } else if (i == currentPhrase.words.length - 1) {
            newWordIndex = i;
          }
        }
      }
    }

    if (newPhraseIndex != state.currentPhraseIndex || newWordIndex != state.currentWordIndex) {
      state = state.copyWith(
        currentPhraseIndex: newPhraseIndex,
        currentWordIndex: newWordIndex,
      );
    }
  }

  void reset() {
    state = state.copyWith(
      currentPhraseIndex: 0,
      currentWordIndex: -1, // Reset to no word highlighted
    );
  }
}

/// Provider for lyrics state
final lyricsProvider = StateNotifierProvider<LyricsNotifier, LyricsState>((ref) {
  return LyricsNotifier();
});

/// Video player controller provider - kept alive to preserve state
final videoControllerProvider = Provider.autoDispose<VideoPlayerController>((ref) {
  // Using the Louane video asset
  final controller = VideoPlayerController.asset('assets/videos/louane.mp4');

  // Keep the controller alive even when navigating away
  final keepAliveLink = ref.keepAlive();

  // Don't automatically dispose - keep alive indefinitely
  // This preserves video position across navigation

  // Clean up when provider is disposed
  ref.onDispose(() {
    controller.dispose();
    keepAliveLink.close();
  });

  return controller;
});
