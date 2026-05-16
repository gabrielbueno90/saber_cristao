class QuizSessionModel {
  const QuizSessionModel({
    required this.level,
    required this.index,
    required this.correctCount,
    required this.wrongCount,
    required this.score,
  });

  final int level;
  final int index;
  final int correctCount;
  final int wrongCount;
  final int score;

  QuizSessionModel copyWith({
    int? level,
    int? index,
    int? correctCount,
    int? wrongCount,
    int? score,
  }) {
    return QuizSessionModel(
      level: level ?? this.level,
      index: index ?? this.index,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      score: score ?? this.score,
    );
  }
}
