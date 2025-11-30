import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class LyricsDisplay extends StatelessWidget {
  const LyricsDisplay({
    super.key,
    required this.lyrics,
    required this.currentLineIndex,
  });

  final List<String> lyrics;
  final int currentLineIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      itemCount: lyrics.length,
      itemBuilder: (context, index) {
        final isCurrentLine = index == currentLineIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingXs),
          child: AnimatedDefaultTextStyle(
            duration: AppConstants.shortDuration,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: isCurrentLine ? FontWeight.bold : FontWeight.normal,
                  color: isCurrentLine
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: isCurrentLine ? 18 : 16,
                ),
            child: Text(
              lyrics[index],
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
