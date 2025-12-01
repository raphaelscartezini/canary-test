class Word {
  final String text;
  final double startTime; // Time in seconds when this word starts
  final double endTime; // Time in seconds when this word ends

  const Word({
    required this.text,
    required this.startTime,
    required this.endTime,
  });
}

class LyricPhrase {
  final List<Word> words;
  final double startTime; // Start time of the phrase
  final double endTime; // End time of the phrase

  const LyricPhrase({
    required this.words,
    required this.startTime,
    required this.endTime,
  });

  // Get the full phrase text
  String get text => words.map((w) => w.text).join(' ');
}
