import 'package:flutter/services.dart';
import 'package:subtitle/subtitle.dart';
import '../../features/lyrics_quiz/models/lyric_line.dart';
import '../../features/lyrics_quiz/models/word.dart';

/// Utility class for parsing SRT subtitle files
class SrtParser {
  /// Load and parse an SRT file from assets
  /// Returns a list of LyricLine objects with text and timestamps
  static Future<List<LyricLine>> loadFromAsset(String assetPath) async {
    try {
      // Load the SRT file content from assets
      final srtContent = await rootBundle.loadString(assetPath);

      // Parse the SRT content using the subtitle package
      final controller = SubtitleController(
        provider: SubtitleProvider.fromString(
          data: srtContent,
          type: SubtitleType.srt,
        ),
      );

      await controller.initial();

      // Convert subtitles to LyricLine objects
      final lyrics = <LyricLine>[];
      for (final subtitle in controller.subtitles) {
        // Get the start time in seconds
        final startTime = subtitle.start.inMilliseconds / 1000.0;

        // Get the text (remove any formatting tags if present)
        final text = subtitle.data;

        lyrics.add(LyricLine(
          text: text,
          startTime: startTime,
        ));
      }

      return lyrics;
    } catch (e) {
      throw Exception('Failed to load SRT file: $e');
    }
  }

  /// Parse SRT content from a string
  static List<LyricLine> parseFromString(String srtContent) {
    try {
      final controller = SubtitleController(
        provider: SubtitleProvider.fromString(
          data: srtContent,
          type: SubtitleType.srt,
        ),
      );

      controller.initial();

      final lyrics = <LyricLine>[];
      for (final subtitle in controller.subtitles) {
        final startTime = subtitle.start.inMilliseconds / 1000.0;
        final text = subtitle.data;

        lyrics.add(LyricLine(
          text: text,
          startTime: startTime,
        ));
      }

      return lyrics;
    } catch (e) {
      throw Exception('Failed to parse SRT content: $e');
    }
  }

  /// Load and parse a word-level SRT file from assets
  /// Groups words into phrases and returns a list of LyricPhrase objects
  static Future<List<LyricPhrase>> loadWordsFromAsset(String assetPath) async {
    try {
      // Load the SRT file content from assets
      final srtContent = await rootBundle.loadString(assetPath);

      // Parse the SRT content using the subtitle package
      final controller = SubtitleController(
        provider: SubtitleProvider.fromString(
          data: srtContent,
          type: SubtitleType.srt,
        ),
      );

      await controller.initial();

      // Convert subtitles to Word objects
      final words = <Word>[];
      for (final subtitle in controller.subtitles) {
        final startTime = subtitle.start.inMilliseconds / 1000.0;
        final endTime = subtitle.end.inMilliseconds / 1000.0;
        final text = subtitle.data.trim();

        words.add(Word(
          text: text,
          startTime: startTime,
          endTime: endTime,
        ));
      }

      // Group words into phrases (sentences)
      // A phrase ends when there's a significant gap (>0.5s) or punctuation
      final phrases = <LyricPhrase>[];
      List<Word> currentPhraseWords = [];

      for (int i = 0; i < words.length; i++) {
        currentPhraseWords.add(words[i]);

        // Check if this is the end of a phrase
        bool isEndOfPhrase = false;

        // Check for punctuation
        final hasEndPunctuation = words[i].text.endsWith(',') ||
                                  words[i].text.endsWith('.') ||
                                  words[i].text.endsWith('!') ||
                                  words[i].text.endsWith('?');

        // Check for gap to next word
        final hasGap = i < words.length - 1 &&
                       (words[i + 1].startTime - words[i].endTime) > 0.5;

        // Last word
        final isLast = i == words.length - 1;

        isEndOfPhrase = hasEndPunctuation || hasGap || isLast;

        if (isEndOfPhrase && currentPhraseWords.isNotEmpty) {
          phrases.add(LyricPhrase(
            words: List.from(currentPhraseWords),
            startTime: currentPhraseWords.first.startTime,
            endTime: currentPhraseWords.last.endTime,
          ));
          currentPhraseWords = [];
        }
      }

      return phrases;
    } catch (e) {
      throw Exception('Failed to load word-level SRT file: $e');
    }
  }
}
