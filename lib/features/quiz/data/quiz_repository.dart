import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/core/supabase/supabase_client_provider.dart';
import 'package:saber_cristao/features/quiz/domain/question_model.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizQuestionLoadResult {
  const QuizQuestionLoadResult({
    required this.questions,
    required this.fromSupabase,
    this.warning,
  });

  final List<QuestionModel> questions;
  final bool fromSupabase;
  final String? warning;
}

abstract class QuizRepository {
  bool get isUsingSupabase;
  Future<QuizQuestionLoadResult> fetchQuestions({
    required int level,
    required int difficulty,
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
  Future<QuizQuestionLoadResult> fetchQuestions({
    required int level,
    required int difficulty,
    required String language,
    int limit = 5,
  }) async {
    if (_client == null) {
      return const QuizQuestionLoadResult(
        questions: [],
        fromSupabase: false,
        warning: 'Supabase não configurado. Usando fallback mock.',
      );
    }
    final client = _client;
    final exactRows = await client
        .from('questions')
        .select()
        .eq('language', language)
        .eq('is_active', true)
        .eq('review_status', 'approved')
        .eq('level', level)
        .eq('difficulty', difficulty)
        .limit(40);

    final exactQuestions = _mapRows(exactRows);
    exactQuestions.shuffle();

    final selected = exactQuestions.take(limit).toList();
    var warning = selected.length < limit
        ? 'Poucas perguntas no nível exato. Completando pela dificuldade da fase.'
        : null;

    if (selected.length < limit) {
      final difficultyRows = await client
          .from('questions')
          .select()
          .eq('language', language)
          .eq('is_active', true)
          .eq('review_status', 'approved')
          .eq('difficulty', difficulty)
          .limit(80);

      final usedIds = selected.map((item) => item.id).toSet();
      final fallbackQuestions = _mapRows(difficultyRows)
          .where((item) => !usedIds.contains(item.id))
          .toList()
        ..shuffle();
      selected.addAll(fallbackQuestions.take(limit - selected.length));
    }

    if (selected.isEmpty) {
      warning = 'Sem perguntas aprovadas para esta fase. Usando fallback mock.';
    } else if (selected.length < limit) {
      warning = 'Banco retornou menos perguntas que o ideal para esta fase.';
    }

    return QuizQuestionLoadResult(
      questions: selected,
      fromSupabase: selected.isNotEmpty,
      warning: warning,
    );
  }

  List<QuestionModel> _mapRows(Object rows) {
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
  Future<QuizQuestionLoadResult> fetchQuestions({
    required int level,
    required int difficulty,
    required String language,
    int limit = 5,
  }) async {
    final questions = const [
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
    return QuizQuestionLoadResult(
      questions: questions.take(limit).toList(),
      fromSupabase: false,
      warning: 'Modo mock ativo.',
    );
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
