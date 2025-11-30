import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../models/question.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_question_card.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final quizNotifier = ref.read(quizProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('French Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Reset quiz when going back
            quizNotifier.reset();
            context.go('/lyrics');
          },
        ),
      ),
      body: Column(
        children: [
          // Quiz questions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              itemCount: Question.sampleQuestions.length,
              itemBuilder: (context, index) {
                final question = Question.sampleQuestions[index];
                return QuizQuestionCard(
                  question: question,
                  questionNumber: index + 1,
                  selectedAnswer: quizState.selectedAnswers[index],
                  onAnswerSelected: (answerIndex) {
                    quizNotifier.selectAnswer(index, answerIndex);
                  },
                  isSubmitted: quizState.isSubmitted,
                );
              },
            ),
          ),

          // Result or Submit button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                children: [
                  // Show result if submitted
                  if (quizState.isSubmitted) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.spacingL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusM),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            quizState.score == Question.sampleQuestions.length
                                ? Icons.emoji_events_rounded
                                : Icons.star_rounded,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          Text(
                            'You got ${quizState.score}/${Question.sampleQuestions.length} correct',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppConstants.spacingXs),
                          Text(
                            quizState.score == Question.sampleQuestions.length
                                ? 'Perfect score! 🎉'
                                : quizState.score >= 2
                                    ? 'Great job! 👏'
                                    : 'Keep practicing! 💪',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingM),

                    // Retake Quiz button
                    FilledButton(
                      onPressed: () {
                        quizNotifier.reset();
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Retake Quiz'),
                    ),
                  ] else ...[
                    // Submit button (only enabled if all questions answered)
                    FilledButton(
                      onPressed: quizState.selectedAnswers.contains(null)
                          ? null
                          : () {
                              quizNotifier.submitQuiz();
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Submit'),
                    ),
                    if (quizState.selectedAnswers.contains(null))
                      Padding(
                        padding: const EdgeInsets.only(
                            top: AppConstants.spacingS),
                        child: Text(
                          'Please answer all questions to submit',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
