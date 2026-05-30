import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:saber_cristao/features/progress/presentation/progress_controller.dart';
import 'package:saber_cristao/features/quiz/data/quiz_repository.dart';
import 'package:saber_cristao/features/quiz/domain/question_model.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_session_model.dart';

class QuizController extends StateNotifier<QuizSessionModel> {
  QuizController(this._ref)
      : super(
          const QuizSessionModel(
            level: 1,
            index: 0,
            correctCount: 0,
            wrongCount: 0,
            score: 0,
          ),
        ) {
    _loadQuestions();
  }

  final Ref _ref;
  List<QuestionModel> _questions = const [];
  QuizResultModel? _lastResult;
  bool _questionsFromSupabase = false;
  String? _loadWarning;
  bool _attemptRecorded = false;

  bool get hasQuestions => _questions.isNotEmpty;
  bool get questionsFromSupabase => _questionsFromSupabase;
  String? get loadWarning => _loadWarning;
  int get expectedDifficulty => _difficultyForLevel(state.level);
  int get expectedQuestionCount => _questionCountForLevel(state.level);
  QuestionModel get currentQuestion => _questions[state.index];
  bool get isLastQuestion => state.index >= _questions.length - 1;
  QuizResultModel? get lastResult => _lastResult;

  Future<void> loadLevel(int level) => _loadQuestions(levelOverride: level);

  Future<void> _loadQuestions({int? levelOverride}) async {
    final level = levelOverride ?? _ref.read(progressControllerProvider).currentLevel;
    final difficulty = _difficultyForLevel(level);
    final limit = _questionCountForLevel(level);
    final repo = _ref.read(quizRepositoryProvider);
    try {
      final result = await repo.fetchQuestions(
            level: level,
            difficulty: difficulty,
            language: 'pt-BR',
            limit: limit,
          );
      _questions = result.questions;
      _questionsFromSupabase = repo.isUsingSupabase && result.fromSupabase;
      _loadWarning = result.warning;
    } catch (_) {
      _questions = const [];
      _questionsFromSupabase = false;
      _loadWarning = 'Falha ao carregar perguntas do Supabase. Usando fallback mock.';
    }
    if (_questions.isEmpty) {
      _questions = await const MockQuizRepository().fetchQuestions(
        level: level,
        difficulty: difficulty,
        language: 'pt-BR',
        limit: limit,
      ).then((result) => result.questions);
      _questionsFromSupabase = false;
    }
    _questions.shuffle();
    _attemptRecorded = false;
    state = state.copyWith(level: level, index: 0, score: 0, correctCount: 0, wrongCount: 0);
  }

  QuizResultModel evaluateAnswer(int index) {
    final isCorrect = currentQuestion.correctIndex == index;
    final score = isCorrect ? state.score + 100 : state.score;
    final correct = isCorrect ? state.correctCount + 1 : state.correctCount;
    final wrong = isCorrect ? state.wrongCount : state.wrongCount + 1;
    final stars = isLastQuestion ? _calculateStars(correct: correct, wrong: wrong) : 0;
    return QuizResultModel(
      level: state.level,
      score: score,
      stars: stars,
      correctCount: correct,
      wrongCount: wrong,
    );
  }

  void advanceWithResult(QuizResultModel result) {
    _lastResult = result;
    if (!isLastQuestion) {
      state = state.copyWith(
        index: state.index + 1,
        score: result.score,
        correctCount: result.correctCount,
        wrongCount: result.wrongCount,
      );
      return;
    }
    state = state.copyWith(
      score: result.score,
      correctCount: result.correctCount,
      wrongCount: result.wrongCount,
    );
  }

  int _calculateStars({required int correct, required int wrong}) {
    if (correct == _questions.length) return 3;
    if (wrong <= 1) return 2;
    if (correct > 0) return 1;
    return 0;
  }

  int _difficultyForLevel(int level) {
    if (level <= 5) return 1;
    if (level <= 10) return 2;
    return 3;
  }

  int _questionCountForLevel(int level) {
    if (level <= 5) return 5;
    if (level <= 10) return 7;
    return 10;
  }

  void restart() {
    _lastResult = null;
    _loadWarning = null;
    state = state.copyWith(
      index: 0,
      score: 0,
      correctCount: 0,
      wrongCount: 0,
    );
    _loadQuestions();
  }

  Future<void> recordAttempt(QuizResultModel result) async {
    if (_attemptRecorded) return;
    final auth = _ref.read(authControllerProvider);
    if (auth.status != AuthStatus.authenticated || auth.user == null) return;
    await _ref.read(quizRepositoryProvider).insertAttempt(
          userId: auth.user!.id,
          result: result,
          completed: true,
          usedContinue: false,
        );
    _attemptRecorded = true;
  }
}

final quizControllerProvider =
    StateNotifierProvider<QuizController, QuizSessionModel>((ref) {
  return QuizController(ref);
});
