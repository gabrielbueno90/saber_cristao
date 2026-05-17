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

  factory QuestionModel.fromSupabase(Map<String, dynamic> map) {
    int parseCorrectIndex(String value) {
      switch (value.toUpperCase()) {
        case 'A':
          return 0;
        case 'B':
          return 1;
        case 'C':
          return 2;
        case 'D':
          return 3;
        default:
          return 0;
      }
    }

    return QuestionModel(
      id: map['id'] as String,
      level: (map['level'] as num?)?.toInt() ?? 1,
      question: (map['question_text'] as String?) ?? '',
      options: [
        (map['option_a'] as String?) ?? '',
        (map['option_b'] as String?) ?? '',
        (map['option_c'] as String?) ?? '',
        (map['option_d'] as String?) ?? '',
      ],
      correctIndex: parseCorrectIndex((map['correct_option'] as String?) ?? 'A'),
      explanation: (map['explanation'] as String?) ?? '',
      bibleReference: (map['bible_reference'] as String?) ?? '',
    );
  }
}
