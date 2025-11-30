import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user.dart';
import '../providers/matching_provider.dart';
import '../widgets/user_card.dart';
import '../widgets/matching_modal.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  void _showMatchingModal(BuildContext context, WidgetRef ref, User user) {
    final matchingNotifier = ref.read(matchingProvider.notifier);

    // Start matching process
    matchingNotifier.startMatching(user);

    // Show modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusL),
        ),
      ),
      builder: (context) => MatchingModal(user: user),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Language Partners'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        itemCount: User.sampleUsers.length,
        itemBuilder: (context, index) {
          final user = User.sampleUsers[index];
          return UserCard(
            user: user,
            onMatchTap: () => _showMatchingModal(context, ref, user),
          );
        },
      ),
    );
  }
}
