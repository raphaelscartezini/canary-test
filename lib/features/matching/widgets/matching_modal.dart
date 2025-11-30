import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user.dart';
import '../providers/matching_provider.dart';

class MatchingModal extends ConsumerWidget {
  const MatchingModal({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchingState = ref.watch(matchingProvider);
    final matchingNotifier = ref.read(matchingProvider.notifier);

    return Container(
      padding: EdgeInsets.only(
        top: AppConstants.spacingL,
        left: AppConstants.spacingL,
        right: AppConstants.spacingL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.spacingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),

          // Animated content switcher
          AnimatedSwitcher(
            duration: AppConstants.mediumDuration,
            child: matchingState.isMatching
                ? _MatchingContent(user: user)
                : _MatchedContent(
                    user: user,
                    onViewProfile: () {
                      matchingNotifier.reset();
                      Navigator.pop(context);
                      context.push('/profile/${user.id}', extra: user);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Content shown while matching (loading state)
class _MatchingContent extends StatelessWidget {
  const _MatchingContent({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('matching'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated spinner
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingL),

        Text(
          'Matching...',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          'Finding the perfect language partner',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    );
  }
}

/// Content shown after successful match
class _MatchedContent extends StatelessWidget {
  const _MatchedContent({
    required this.user,
    required this.onViewProfile,
  });

  final User user;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('matched'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Success icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Icon(
            Icons.celebration_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingL),

        Text(
          'Yes! You matched with',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacingS),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(width: AppConstants.spacingS),
            const Text(
              '🎉',
              style: TextStyle(fontSize: 28),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingXl),

        // View Profile button
        FilledButton(
          onPressed: onViewProfile,
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_rounded),
              SizedBox(width: AppConstants.spacingS),
              Text('View Profile'),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
      ],
    );
  }
}
