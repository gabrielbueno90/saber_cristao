import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';
import 'package:saber_cristao/features/quiz/domain/question_model.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class QuizRepository {
  bool get isUsingSupabase;
  Future<List<QuestionModel>> fetchQuestions({
    required int level,
    required String language,
    int limit,
  });

  Future<void> insertAttempt({
    required String userId,
    required QuizResultModel result,
    required bool completed,
    required bool usedContinue,
  });
}

class SupabaseQuizRepository implements QuizRepository {
  SupabaseQuizRepository(this._client);

  final SupabaseClient? _client;

  @override
  bool get isUsingSupabase => true;

  @override
  Future<List<QuestionModel>> fetchQuestions({
    required int level,
    required String language,
    int limit = 5,
  }) async {
    if (_client == null) return const [];
    final client = _client;
    final rows = await client
        .from('questions')
        .select()
        .eq('language', language)
        .eq('is_active', true)
        .eq('review_status', 'approved')
        .eq('level', level)
        .order('difficulty', ascending: true)
        .limit(limit);

    return (rows as List)
        .map((item) => QuestionModel.fromSupabase(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> insertAttempt({
    required String userId,
    required QuizResultModel result,
    required bool completed,
    required bool usedContinue,
  }) async {
    if (_client == null) return;
    final client = _client;
    await client.from('quiz_attempts').insert({
      'user_id': userId,
      'level_id': result.level,
      'score': result.score,
      'stars': result.stars,
      'correct_count': result.correctCount,
      'wrong_count': result.wrongCount,
      'used_continue': usedContinue,
      'completed': completed,
    });
  }
}

class MockQuizRepository implements QuizRepository {
  const MockQuizRepository();

  @override
  bool get isUsingSupabase => false;

  @override
  Future<List<QuestionModel>> fetchQuestions({
    required int level,
    required String language,
    int limit = 5,
  }) async {
    return const [
      QuestionModel(
        id: 'q1',
        level: 1,
        question: 'Quem construiu a arca?',
        options: ['Abraão', 'Noé', 'Moisés', 'Davi'],
        correctIndex: 1,
        explanation: 'Noé construiu a arca por obediência a Deus.',
        bibleReference: 'Gênesis 6:14',
      ),
      QuestionModel(
        id: 'q2',
        level: 1,
        question: 'Qual evangelho começa com "No princípio era o Verbo"?',
        options: ['Mateus', 'Marcos', 'Lucas', 'João'],
        correctIndex: 3,
        explanation: 'Essa abertura está no evangelho de João.',
        bibleReference: 'João 1:1',
      ),
      QuestionModel(
        id: 'q3',
        level: 1,
        question: 'Quantos livros tem o Novo Testamento?',
        options: ['27', '39', '66', '12'],
        correctIndex: 0,
        explanation: 'O Novo Testamento possui 27 livros.',
        bibleReference: 'Cânon bíblico',
      ),
    ];
  }

  @override
  Future<void> insertAttempt({
    required String userId,
    required QuizResultModel result,
    required bool completed,
    required bool usedContinue,
  }) async {}
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  if (client == null) return const MockQuizRepository();
  return SupabaseQuizRepository(client);
});
