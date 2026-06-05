import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:saber_cristao/features/levels/domain/user_level_progress_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserLevelProgressRepository {
  Future<List<UserLevelProgressModel>> fetchMyProgress(String userId);
  Future<void> upsertMyProgress({
    required String userId,
    required int level,
    required int score,
    required int stars,
    required bool completed,
  });
}

class SupabaseUserLevelProgressRepository
    implements UserLevelProgressRepository {
  SupabaseUserLevelProgressRepository(this._client);

  final SupabaseClient? _client;

  @override
  Future<List<UserLevelProgressModel>> fetchMyProgress(String userId) async {
    if (_client == null) return const [];
    final rows = await _client
        .from('user_level_progress')
        .select()
        .eq('user_id', userId)
        .order('level', ascending: true);

    return (rows as List)
        .map((row) => UserLevelProgressModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> upsertMyProgress({
    required String userId,
    required int level,
    required int score,
    required int stars,
    required bool completed,
  }) async {
    if (_client == null) return;

    final existing = await _client
        .from('user_level_progress')
        .select()
        .eq('user_id', userId)
        .eq('level', level)
        .maybeSingle();

    final attemptsCount =
        ((existing?['attempts_count'] as num?)?.toInt() ?? 0) + 1;
    final bestScore = score > ((existing?['best_score'] as num?)?.toInt() ?? 0)
        ? score
        : ((existing?['best_score'] as num?)?.toInt() ?? 0);
    final bestStars = stars > ((existing?['best_stars'] as num?)?.toInt() ?? 0)
        ? stars
        : ((existing?['best_stars'] as num?)?.toInt() ?? 0);
    final wasCompleted = (existing?['completed'] as bool?) ?? false;

    await _client.from('user_level_progress').upsert({
      'user_id': userId,
      'level': level,
      'best_score': bestScore,
      'best_stars': bestStars,
      'completed': wasCompleted || completed,
      'attempts_count': attemptsCount,
      'last_played_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'user_id,level');
  }
}

class MockUserLevelProgressRepository implements UserLevelProgressRepository {
  const MockUserLevelProgressRepository();

  @override
  Future<List<UserLevelProgressModel>> fetchMyProgress(String userId) async =>
      const [];

  @override
  Future<void> upsertMyProgress({
    required String userId,
    required int level,
    required int score,
    required int stars,
    required bool completed,
  }) async {}
}

final userLevelProgressRepositoryProvider =
    Provider<UserLevelProgressRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const MockUserLevelProgressRepository();
  return SupabaseUserLevelProgressRepository(client);
});

final myLevelProgressProvider =
    FutureProvider<List<UserLevelProgressModel>>((ref) async {
  final auth = ref.watch(authControllerProvider);
  if (auth.status != AuthStatus.authenticated || auth.user == null) {
    return const [];
  }
  return ref
      .read(userLevelProgressRepositoryProvider)
      .fetchMyProgress(auth.user!.id);
});
