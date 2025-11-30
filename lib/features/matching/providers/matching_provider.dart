import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

/// State for matching process
class MatchingState {
  final User? matchingUser;
  final bool isMatching;
  final bool isMatched;

  const MatchingState({
    this.matchingUser,
    this.isMatching = false,
    this.isMatched = false,
  });

  MatchingState copyWith({
    User? matchingUser,
    bool? isMatching,
    bool? isMatched,
  }) {
    return MatchingState(
      matchingUser: matchingUser ?? this.matchingUser,
      isMatching: isMatching ?? this.isMatching,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

/// Matching state notifier
class MatchingNotifier extends StateNotifier<MatchingState> {
  MatchingNotifier() : super(const MatchingState());

  /// Start matching process with a user
  Future<void> startMatching(User user) async {
    state = MatchingState(
      matchingUser: user,
      isMatching: true,
      isMatched: false,
    );

    // Simulate network delay (1 second as per requirements)
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      state = state.copyWith(
        isMatching: false,
        isMatched: true,
      );
    }
  }

  /// Reset matching state
  void reset() {
    state = const MatchingState();
  }
}

/// Provider for matching state
final matchingProvider =
    StateNotifierProvider<MatchingNotifier, MatchingState>((ref) {
  return MatchingNotifier();
});
