class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  // Sample quiz questions about French language learning
  static const List<Question> sampleQuestions = [
    Question(
      questionText: "What does 'merci' mean in English?",
      options: ['Hello', 'Thank you', 'Goodbye'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: "How do you say 'good morning' in French?",
      options: ['Bonjour', 'Bonsoir', 'Bonne nuit'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: "What does 's'il vous plaît' mean?",
      options: ['Excuse me', 'Please', 'Sorry'],
      correctAnswerIndex: 1,
    ),
  ];
}
