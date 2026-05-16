import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/lives/presentation/lives_controller.dart';

class ProgressState {
  const ProgressState({
    required this.currentLevel,
    required this.totalStars,
    required this.totalScore,
    required this.lastSyncAt,
  });

  final int currentLevel;
  final int totalStars;
  final int totalScore;
  final DateTime? lastSyncAt;

  ProgressState copyWith({
    int? currentLevel,
    int? totalStars,
    int? totalScore,
    DateTime? lastSyncAt,
  }) {
    return ProgressState(
      currentLevel: currentLevel ?? this.currentLevel,
      totalStars: totalStars ?? this.totalStars,
      totalScore: totalScore ?? this.totalScore,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
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
          ),
        );

  final Ref _ref;

  Future<void> applyQuizResult({
    required int stars,
    required int score,
    required bool completed,
  }) async {
    state = state.copyWith(
      totalStars: state.totalStars + stars,
      totalScore: state.totalScore + score,
      currentLevel: completed ? state.currentLevel + 1 : state.currentLevel,
    );
    await _ref.read(localStorageProvider).saveStars(state.totalStars);
  }
}

final progressControllerProvider =
    StateNotifierProvider<ProgressController, ProgressState>((ref) {
  return ProgressController(ref);
});
