import 'package:flutter/services.dart';
import '../../features/lyrics_quiz/models/lyric_line.dart';
import '../../features/lyrics_quiz/models/word.dart';

/// Utility class for parsing SRT subtitle files
class SrtParser {
  /// Parse SRT timestamp to seconds
  static double _parseTimestamp(String timestamp) {
    // Format: HH:MM:SS,mmm
    final parts = timestamp.trim().split(':');
    if (parts.length != 3) throw FormatException('Invalid timestamp: $timestamp');

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secondsParts = parts[2].split(',');
    final seconds = int.parse(secondsParts[0]);
    final milliseconds = int.parse(secondsParts[1]);

    return hours * 3600.0 + minutes * 60.0 + seconds + milliseconds / 1000.0;
  }
  /// Load and parse an SRT file from assets
  /// Returns a list of LyricLine objects with text and timestamps
  static Future<List<LyricLine>> loadFromAsset(String assetPath) async {
    try {
      // Load the SRT file content from assets
      final srtContent = await rootBundle.loadString(assetPath);
      return parseFromString(srtContent);
    } catch (e) {
      throw Exception('Failed to load SRT file: $e');
    }
  }

  /// Parse SRT content from a string
  static List<LyricLine> parseFromString(String srtContent) {
    try {
      final lyrics = <LyricLine>[];

      // Split into subtitle blocks (separated by blank lines)
      final blocks = srtContent.split('\n\n').where((b) => b.trim().isNotEmpty);

      for (final block in blocks) {
        final lines = block.split('\n').where((l) => l.trim().isNotEmpty).toList();
        if (lines.length < 3) continue; // Need at least: number, timestamp, text

        // Line 0: index (skip)
        // Line 1: timestamp line (format: start --> end)
        final timestampLine = lines[1];
        final timestamps = timestampLine.split('-->');
        if (timestamps.length != 2) continue;

        final startTime = _parseTimestamp(timestamps[0]);

        // Lines 2+: text content
        final text = lines.sublist(2).join(' ').trim();

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
      print('DEBUG: SRT content loaded, length: ${srtContent.length}');

      // Convert subtitles to Word objects using custom parser
      final words = <Word>[];

      // Split into subtitle blocks (separated by blank lines)
      final blocks = srtContent.split('\n\n').where((b) => b.trim().isNotEmpty);
      print('DEBUG: Found ${blocks.length} subtitle blocks');

      for (final block in blocks) {
        final lines = block.split('\n').where((l) => l.trim().isNotEmpty).toList();
        if (lines.length < 3) continue; // Need at least: number, timestamp, text

        try {
          // Line 0: index (skip)
          // Line 1: timestamp line (format: start --> end)
          final timestampLine = lines[1];
          final timestamps = timestampLine.split('-->');
          if (timestamps.length != 2) continue;

          final startTime = _parseTimestamp(timestamps[0]);
          final endTime = _parseTimestamp(timestamps[1]);

          // Lines 2+: text content
          final text = lines.sublist(2).join(' ').trim();

          words.add(Word(
            text: text,
            startTime: startTime,
            endTime: endTime,
          ));
        } catch (e) {
          print('DEBUG: Error parsing block: $e');
          continue;
        }
      }
      print('DEBUG: Converted ${words.length} words from subtitles');

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

      print('DEBUG: Created ${phrases.length} phrases from words');
      if (phrases.isNotEmpty) {
        print('DEBUG: First phrase: "${phrases.first.text}" (${phrases.first.words.length} words)');
      }
      return phrases;
    } catch (e) {
      print('DEBUG ERROR: Failed to load word-level SRT file: $e');
      throw Exception('Failed to load word-level SRT file: $e');
    }
  }
}
