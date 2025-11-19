import 'package:cloud_firestore/cloud_firestore.dart';

/// Achievement/Badge model
class Achievement {
  final String achievementId;
  final String name;
  final String description;
  final String icon;
  final int targetValue;
  final String category; // 'questions', 'streak', 'subject', 'performance'
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentProgress;

  const Achievement({
    required this.achievementId,
    required this.name,
    required this.description,
    required this.icon,
    required this.targetValue,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  /// Create Achievement from JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achievementId: json['achievementId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      targetValue: json['targetValue'] as int,
      category: json['category'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? (json['unlockedAt'] as Timestamp).toDate()
          : null,
      currentProgress: json['currentProgress'] as int? ?? 0,
    );
  }

  /// Convert Achievement to JSON
  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'name': name,
      'description': description,
      'icon': icon,
      'targetValue': targetValue,
      'category': category,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
      'currentProgress': currentProgress,
    };
  }

  /// Create a copy with updated fields
  Achievement copyWith({
    String? achievementId,
    String? name,
    String? description,
    String? icon,
    int? targetValue,
    String? category,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? currentProgress,
  }) {
    return Achievement(
      achievementId: achievementId ?? this.achievementId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      targetValue: targetValue ?? this.targetValue,
      category: category ?? this.category,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  /// Get progress percentage
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    final progress = (currentProgress / targetValue).clamp(0.0, 1.0);
    return progress;
  }

  /// Check if achievement is almost unlocked (>= 80% progress)
  bool get isAlmostUnlocked {
    return !isUnlocked && progressPercentage >= 0.8;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          achievementId == other.achievementId;

  @override
  int get hashCode => achievementId.hashCode;

  @override
  String toString() {
    return 'Achievement(achievementId: $achievementId, name: $name, isUnlocked: $isUnlocked, progress: $currentProgress/$targetValue)';
  }

  /// Predefined achievements
  static List<Achievement> get defaultAchievements {
    return [
      Achievement(
        achievementId: 'first_question',
        name: 'İlk Adım',
        description: 'İlk sorunuzu çözdünüz!',
        icon: '🎯',
        targetValue: 1,
        category: 'questions',
      ),
      Achievement(
        achievementId: 'beginner',
        name: 'Başlangıç',
        description: '10 soru çözdünüz',
        icon: '📚',
        targetValue: 10,
        category: 'questions',
      ),
      Achievement(
        achievementId: 'intermediate',
        name: 'Gelişen Öğrenci',
        description: '50 soru çözdünüz',
        icon: '🌟',
        targetValue: 50,
        category: 'questions',
      ),
      Achievement(
        achievementId: 'advanced',
        name: 'İleri Seviye',
        description: '100 soru çözdünüz',
        icon: '🏆',
        targetValue: 100,
        category: 'questions',
      ),
      Achievement(
        achievementId: 'expert',
        name: 'Uzman',
        description: '250 soru çözdünüz',
        icon: '💎',
        targetValue: 250,
        category: 'questions',
      ),
      Achievement(
        achievementId: 'master',
        name: 'Usta',
        description: '500 soru çözdünüz',
        icon: '👑',
        targetValue: 500,
        category: 'questions',
      ),
      Achievement(
        achievementId: 'streak_3',
        name: '3 Günlük Seri',
        description: '3 gün üst üste soru çözdünüz',
        icon: '🔥',
        targetValue: 3,
        category: 'streak',
      ),
      Achievement(
        achievementId: 'streak_7',
        name: 'Haftalık Seri',
        description: '7 gün üst üste soru çözdünüz',
        icon: '🔥🔥',
        targetValue: 7,
        category: 'streak',
      ),
      Achievement(
        achievementId: 'streak_30',
        name: 'Aylık Seri',
        description: '30 gün üst üste soru çözdünüz',
        icon: '🔥🔥🔥',
        targetValue: 30,
        category: 'streak',
      ),
    ];
  }
}
