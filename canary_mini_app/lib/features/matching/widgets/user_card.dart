import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.onMatchTap,
  });

  final User user;
  final VoidCallback onMatchTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large profile image at top (takes good chunk of card)
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(
              user.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),

          // User info section
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and age
                Row(
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: AppConstants.spacingXs),
                    Text(
                      '${user.age}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXs),

                // Country
                Row(
                  children: [
                    Text(
                      user.countryFlag,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: AppConstants.spacingXs),
                    Text(
                      user.country,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Learning language badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingM,
                    vertical: AppConstants.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school_rounded, size: 18),
                      const SizedBox(width: AppConstants.spacingS),
                      Text(
                        'Learning: ${user.learningLanguage} ${user.learningLanguageFlag}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Bio
                Text(
                  user.bio,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Interests
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children: user.interests.map((interest) {
                    return Chip(
                      label: Text(interest),
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                      ),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppConstants.spacingM),

                // Match button
                FilledButton(
                  onPressed: onMatchTap,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite_rounded, size: 20),
                      const SizedBox(width: AppConstants.spacingS),
                      Text('Learn with ${user.name.split(' ')[0]}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
