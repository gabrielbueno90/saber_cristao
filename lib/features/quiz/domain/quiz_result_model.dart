class QuizResultModel {
  const QuizResultModel({
    required this.level,
    required this.score,
    required this.stars,
    required this.correctCount,
    required this.wrongCount,
  });

  final int level;
  final int score;
  final int stars;
  final int correctCount;
  final int wrongCount;
}
