import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/question.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    required this.isSubmitted,
  });

  final Question question;
  final int questionNumber;
  final int? selectedAnswer;
  final Function(int) onAnswerSelected;
  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Text(
              'Question $questionNumber',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Answer options
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedAnswer == index;
              final isCorrect = index == question.correctAnswerIndex;
              final showResult = isSubmitted;

              Color? backgroundColor;
              Color? borderColor;
              Color? textColor;

              if (showResult) {
                if (isCorrect) {
                  backgroundColor = Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.5);
                  borderColor = Theme.of(context).colorScheme.primary;
                  textColor = Theme.of(context).colorScheme.primary;
                } else if (isSelected && !isCorrect) {
                  backgroundColor = Theme.of(context)
                      .colorScheme
                      .errorContainer
                      .withOpacity(0.5);
                  borderColor = Theme.of(context).colorScheme.error;
                  textColor = Theme.of(context).colorScheme.error;
                }
              } else if (isSelected) {
                backgroundColor = Theme.of(context).colorScheme.primaryContainer;
                borderColor = Theme.of(context).colorScheme.primary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
                child: InkWell(
                  onTap: isSubmitted ? null : () => onAnswerSelected(index),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: borderColor ??
                            Theme.of(context).colorScheme.outline,
                        width: borderColor != null ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    ),
                    child: Row(
                      children: [
                        // Option letter (A, B, C)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: textColor?.withOpacity(0.2) ??
                                Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingM),

                        // Option text
                        Expanded(
                          child: Text(
                            question.options[index],
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: textColor,
                                    ),
                          ),
                        ),

                        // Check/Cross icon for submitted state
                        if (showResult && (isCorrect || isSelected))
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.error,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
