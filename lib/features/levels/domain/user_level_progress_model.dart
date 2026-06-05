class UserLevelProgressModel {
  const UserLevelProgressModel({
    required this.level,
    required this.bestScore,
    required this.bestStars,
    required this.completed,
    required this.attemptsCount,
    required this.lastPlayedAt,
  });

  final int level;
  final int bestScore;
  final int bestStars;
  final bool completed;
  final int attemptsCount;
  final DateTime? lastPlayedAt;

  factory UserLevelProgressModel.fromJson(Map<String, dynamic> json) {
    return UserLevelProgressModel(
      level: (json['level'] as num?)?.toInt() ?? 0,
      bestScore: (json['best_score'] as num?)?.toInt() ?? 0,
      bestStars: (json['best_stars'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      attemptsCount: (json['attempts_count'] as num?)?.toInt() ?? 0,
      lastPlayedAt: json['last_played_at'] == null
          ? null
          : DateTime.tryParse(json['last_played_at'].toString()),
    );
  }
}
