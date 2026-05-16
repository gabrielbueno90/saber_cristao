import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saber_cristao/features/quiz/domain/question_model.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_session_model.dart';

final mockQuestionsProvider = Provider<List<QuestionModel>>((_) {
  return const [
    QuestionModel(
      id: 'q1',
      level: 1,
      question: 'Quem construiu a arca?',
      options: ['Abraao', 'Noe', 'Moises', 'Davi'],
      correctIndex: 1,
      explanation: 'Noe construiu a arca por obediencia a Deus.',
      bibleReference: 'Genesis 6:14',
    ),
    QuestionModel(
      id: 'q2',
      level: 1,
      question: 'Qual evangelho comeca com "No principio era o Verbo"?',
      options: ['Mateus', 'Marcos', 'Lucas', 'Joao'],
      correctIndex: 3,
      explanation: 'Essa abertura esta no evangelho de Joao.',
      bibleReference: 'Joao 1:1',
    ),
    QuestionModel(
      id: 'q3',
      level: 1,
      question: 'Quantos livros tem o Novo Testamento?',
      options: ['27', '39', '66', '12'],
      correctIndex: 0,
      explanation: 'O Novo Testamento possui 27 livros.',
      bibleReference: 'Canon biblico',
    ),
  ];
});

class QuizController extends StateNotifier<QuizSessionModel> {
  QuizController(this._questions)
      : super(
          const QuizSessionModel(
            level: 1,
            index: 0,
            correctCount: 0,
            wrongCount: 0,
            score: 0,
          ),
        );

  final List<QuestionModel> _questions;

  QuestionModel get currentQuestion => _questions[state.index];
  bool get isLastQuestion => state.index >= _questions.length - 1;

  QuizResultModel answer(int index) {
    final isCorrect = currentQuestion.correctIndex == index;
    final score = isCorrect ? state.score + 100 : state.score;
    final correct = isCorrect ? state.correctCount + 1 : state.correctCount;
    final wrong = isCorrect ? state.wrongCount : state.wrongCount + 1;

    if (isLastQuestion) {
      final stars = _calculateStars(correct: correct, wrong: wrong);
      return QuizResultModel(
        level: state.level,
        score: score,
        stars: stars,
        correctCount: correct,
        wrongCount: wrong,
      );
    }

    state = state.copyWith(
      index: state.index + 1,
      score: score,
      correctCount: correct,
      wrongCount: wrong,
    );
    return QuizResultModel(
      level: state.level,
      score: score,
      stars: 0,
      correctCount: correct,
      wrongCount: wrong,
    );
  }

  int _calculateStars({required int correct, required int wrong}) {
    if (correct == _questions.length) return 3;
    if (wrong <= 1) return 2;
    if (correct > 0) return 1;
    return 0;
  }

  void restart() {
    state = state.copyWith(
      index: 0,
      score: 0,
      correctCount: 0,
      wrongCount: 0,
    );
  }
}

final quizControllerProvider =
    StateNotifierProvider<QuizController, QuizSessionModel>((ref) {
  return QuizController(ref.watch(mockQuestionsProvider));
});
