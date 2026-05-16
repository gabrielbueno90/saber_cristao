class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.level,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.bibleReference,
  });

  final String id;
  final int level;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String bibleReference;
}
