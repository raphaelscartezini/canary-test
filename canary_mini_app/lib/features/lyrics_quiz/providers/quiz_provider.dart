import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';

/// State class to hold quiz data
class QuizState {
  final List<int?> selectedAnswers;
  final bool isSubmitted;
  final int score;

  const QuizState({
    required this.selectedAnswers,
    this.isSubmitted = false,
    this.score = 0,
  });

  QuizState copyWith({
    List<int?>? selectedAnswers,
    bool? isSubmitted,
    int? score,
  }) {
    return QuizState(
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      score: score ?? this.score,
    );
  }
}

/// Quiz state notifier
class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier()
      : super(QuizState(
          selectedAnswers: List.filled(Question.sampleQuestions.length, null),
        ));

  void selectAnswer(int questionIndex, int answerIndex) {
    final newAnswers = List<int?>.from(state.selectedAnswers);
    newAnswers[questionIndex] = answerIndex;
    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void submitQuiz() {
    int correctCount = 0;

    for (int i = 0; i < Question.sampleQuestions.length; i++) {
      final selectedAnswer = state.selectedAnswers[i];
      final correctAnswer = Question.sampleQuestions[i].correctAnswerIndex;

      if (selectedAnswer == correctAnswer) {
        correctCount++;
      }
    }

    state = state.copyWith(
      isSubmitted: true,
      score: correctCount,
    );
  }

  void reset() {
    state = QuizState(
      selectedAnswers: List.filled(Question.sampleQuestions.length, null),
    );
  }
}

/// Provider for quiz state
final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});
