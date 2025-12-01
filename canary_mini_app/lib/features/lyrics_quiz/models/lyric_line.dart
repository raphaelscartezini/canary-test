class LyricLine {
  final String text;
  final double startTime; // Time in seconds when this line should be highlighted

  const LyricLine({
    required this.text,
    required this.startTime,
  });
}
