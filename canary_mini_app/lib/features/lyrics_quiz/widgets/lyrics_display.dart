import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/lyrics_provider.dart';

class LyricsDisplay extends ConsumerWidget {
  const LyricsDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lyricsState = ref.watch(lyricsProvider);
    final phrases = lyricsState.phrases;
    final currentPhraseIndex = lyricsState.currentPhraseIndex;
    final currentWordIndex = lyricsState.currentWordIndex;

    print('DEBUG LyricsDisplay: phrases=${phrases.length}, phraseIdx=$currentPhraseIndex, wordIdx=$currentWordIndex');

    // Only show current phrase if we have lyrics
    if (phrases.isEmpty || currentPhraseIndex >= phrases.length) {
      print('DEBUG LyricsDisplay: Not showing (empty or out of range)');
      return const SizedBox.shrink();
    }

    final currentPhrase = phrases[currentPhraseIndex];
    final words = currentPhrase.words;

    // Don't show lyrics if the first word hasn't started yet
    // (show only when within 1 second before the first word starts)
    // This is handled in the provider, but we can add extra check here
    if (currentWordIndex < 0) {
      print('DEBUG LyricsDisplay: Not showing (word index < 0)');
      return const SizedBox.shrink();
    }

    print('DEBUG LyricsDisplay: Showing phrase "${ currentPhrase.text}" with ${words.length} words');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
        child: AnimatedSwitcher(
          duration: AppConstants.shortDuration,
          child: Wrap(
            key: ValueKey(currentPhraseIndex),
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: List.generate(words.length, (index) {
              final word = words[index];
              final isCurrentWord = index == currentWordIndex;
              final isPastWord = currentWordIndex >= 0 && index < currentWordIndex;

              return AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCurrentWord
                          ? Colors.yellow
                          : (isPastWord ? Colors.white.withOpacity(0.7) : Colors.white),
                      fontSize: isCurrentWord ? 32 : 24,
                      height: 1.4,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.9),
                          blurRadius: isCurrentWord ? 8 : 6,
                          offset: Offset(0, isCurrentWord ? 3 : 2),
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(0.9),
                          blurRadius: isCurrentWord ? 16 : 12,
                          offset: Offset(0, isCurrentWord ? 4 : 3),
                        ),
                      ],
                    ),
                child: Text(word.text),
              );
            }),
          ),
        ),
      ),
    );
  }
}
