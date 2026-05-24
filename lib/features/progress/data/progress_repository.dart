import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProgressRepository {
  Future<ProgressRemoteData?> fetchMyProgress(String userId);
  Future<void> upsertMyProgress({
    required String userId,
    required ProgressState state,
    required int lives,
    required int maxLives,
    required int credits,
  });
}

class ProgressRemoteData {
  const ProgressRemoteData({
    required this.progress,
    required this.lives,
    required this.maxLives,
    required this.credits,
  });

  final ProgressState progress;
  final int lives;
  final int maxLives;
  final int credits;
}

class SupabaseProgressRepository implements ProgressRepository {
  SupabaseProgressRepository(this._client);

  final SupabaseClient? _client;

  @override
  Future<ProgressRemoteData?> fetchMyProgress(String userId) async {
    if (_client == null) return null;
    final client = _client;
    final row = await client
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) return null;
    return ProgressRemoteData(
      progress: ProgressState(
        currentLevel: (row['current_level'] as num?)?.toInt() ?? 1,
        totalStars: (row['total_stars'] as num?)?.toInt() ?? 0,
        totalScore: (row['total_score'] as num?)?.toInt() ?? 0,
        lastSyncAt: row['last_sync_at'] == null
            ? null
            : DateTime.tryParse(row['last_sync_at'] as String),
        sourceLabel: 'Remoto',
      ),
      lives: (row['lives'] as num?)?.toInt() ?? 5,
      maxLives: (row['max_lives'] as num?)?.toInt() ?? 5,
      credits: (row['credits'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<void> upsertMyProgress({
    required String userId,
    required ProgressState state,
    required int lives,
    required int maxLives,
    required int credits,
  }) async {
    if (_client == null) return;
    final client = _client;
    await client.from('user_progress').upsert({
      'user_id': userId,
      'current_level': state.currentLevel,
      'total_stars': state.totalStars,
      'total_score': state.totalScore,
      'lives': lives,
      'max_lives': maxLives,
      'credits': credits,
      'last_sync_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id');
  }
}

class MockProgressRepository implements ProgressRepository {
  @override
  Future<ProgressRemoteData?> fetchMyProgress(String userId) async => null;

  @override
  Future<void> upsertMyProgress({
    required String userId,
    required ProgressState state,
    required int lives,
    required int maxLives,
    required int credits,
  }) async {}
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return MockProgressRepository();
  return SupabaseProgressRepository(client);
});
