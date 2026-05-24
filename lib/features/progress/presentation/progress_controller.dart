import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/storage/local_storage_service.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:saber_cristao/features/progress/data/progress_repository.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';
import 'package:saber_cristao/features/store/presentation/credits_controller.dart';

class ProgressState {
  const ProgressState({
    required this.currentLevel,
    required this.totalStars,
    required this.totalScore,
    required this.lastSyncAt,
    required this.sourceLabel,
  });

  final int currentLevel;
  final int totalStars;
  final int totalScore;
  final DateTime? lastSyncAt;
  final String sourceLabel;

  ProgressState copyWith({
    int? currentLevel,
    int? totalStars,
    int? totalScore,
    DateTime? lastSyncAt,
    String? sourceLabel,
  }) {
    return ProgressState(
      currentLevel: currentLevel ?? this.currentLevel,
      totalStars: totalStars ?? this.totalStars,
      totalScore: totalScore ?? this.totalScore,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      sourceLabel: sourceLabel ?? this.sourceLabel,
    );
  }
}

class ProgressController extends StateNotifier<ProgressState> {
  ProgressController(this._ref)
      : super(
          const ProgressState(
            currentLevel: 1,
            totalStars: 0,
            totalScore: 0,
            lastSyncAt: null,
            sourceLabel: 'Local/mock',
          ),
        );

  final Ref _ref;

  Future<void> loadForCurrentUser() async {
    final auth = _ref.read(authControllerProvider);
    if (auth.status != AuthStatus.authenticated || auth.user == null) return;

    final remote = await _ref.read(progressRepositoryProvider).fetchMyProgress(
          auth.user!.id,
        );
    if (remote == null) {
      await syncToRemote();
      state = state.copyWith(sourceLabel: 'Local/mock');
      return;
    }

    final merged = ProgressState(
      currentLevel: remote.progress.currentLevel > state.currentLevel
          ? remote.progress.currentLevel
          : state.currentLevel,
      totalStars: remote.progress.totalStars > state.totalStars
          ? remote.progress.totalStars
          : state.totalStars,
      totalScore: remote.progress.totalScore > state.totalScore
          ? remote.progress.totalScore
          : state.totalScore,
      lastSyncAt: DateTime.now(),
      sourceLabel: 'Remoto',
    );
    state = merged;
    await _ref.read(livesControllerProvider.notifier).setLives(remote.lives);
    await _ref.read(creditsControllerProvider.notifier).setCredits(remote.credits);
    await syncToRemote();
  }

  Future<void> applyQuizResult({
    required int stars,
    required int score,
    required bool completed,
  }) async {
    state = state.copyWith(
      totalStars: state.totalStars + stars,
      totalScore: state.totalScore + score,
      currentLevel: completed ? state.currentLevel + 1 : state.currentLevel,
      lastSyncAt: DateTime.now(),
      sourceLabel: state.sourceLabel,
    );
    await _ref.read(localStorageProvider).saveStars(state.totalStars);
    await syncToRemote();
  }

  Future<void> syncToRemote() async {
    final auth = _ref.read(authControllerProvider);
    if (auth.status != AuthStatus.authenticated || auth.user == null) return;

    final lives = _ref.read(livesControllerProvider);
    final credits = _ref.read(creditsControllerProvider);
    await _ref.read(progressRepositoryProvider).upsertMyProgress(
          userId: auth.user!.id,
          state: state,
          lives: lives,
          maxLives: 5,
          credits: credits,
        );
    state = state.copyWith(
      lastSyncAt: DateTime.now(),
      sourceLabel: auth.isUsingSupabase ? 'Remoto' : 'Local/mock',
    );
  }
}

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>((ref) {
  return ProgressController(ref);
});
