import 'package:cloud_firestore/cloud_firestore.dart';
import 'achievement.dart';
import 'subject_stats.dart';
import 'daily_stats.dart';

/// Student analytics and performance tracking
class StudentAnalytics {
  final String userId;
  final int totalQuestionsSolved;
  final int successfulQuestions;
  final int failedQuestions;
  final double overallSuccessRate;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastStudyDate;
  final Map<String, SubjectStats> subjectStats;
  final Map<String, int> weeklyActivity; // "2024-11-19": 15
  final List<Achievement> achievements;
  final Map<String, DailyStats> dailyStats; // "2024-11-19": DailyStats(...)

  const StudentAnalytics({
    required this.userId,
    required this.totalQuestionsSolved,
    required this.successfulQuestions,
    required this.failedQuestions,
    required this.overallSuccessRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStudyDate,
    required this.subjectStats,
    required this.weeklyActivity,
    required this.achievements,
    required this.dailyStats,
  });

  /// Create StudentAnalytics from Firestore document
  factory StudentAnalytics.fromJson(Map<String, dynamic> json) {
    return StudentAnalytics(
      userId: json['userId'] as String,
      totalQuestionsSolved: json['totalQuestionsSolved'] as int? ?? 0,
      successfulQuestions: json['successfulQuestions'] as int? ?? 0,
      failedQuestions: json['failedQuestions'] as int? ?? 0,
      overallSuccessRate: (json['overallSuccessRate'] as num?)?.toDouble() ?? 0.0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastStudyDate: json['lastStudyDate'] != null
          ? (json['lastStudyDate'] as Timestamp).toDate()
          : DateTime.now(),
      subjectStats: (json['subjectStats'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              SubjectStats.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      weeklyActivity: (json['weeklyActivity'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
      achievements: (json['achievements'] as List?)
              ?.map((a) => Achievement.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      dailyStats: (json['dailyStats'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              DailyStats.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
    );
  }

  /// Convert StudentAnalytics to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalQuestionsSolved': totalQuestionsSolved,
      'successfulQuestions': successfulQuestions,
      'failedQuestions': failedQuestions,
      'overallSuccessRate': overallSuccessRate,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastStudyDate': Timestamp.fromDate(lastStudyDate),
      'subjectStats': subjectStats.map((key, value) => MapEntry(key, value.toJson())),
      'weeklyActivity': weeklyActivity,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'dailyStats': dailyStats.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  /// Create empty analytics for new user
  factory StudentAnalytics.empty(String userId) {
    return StudentAnalytics(
      userId: userId,
      totalQuestionsSolved: 0,
      successfulQuestions: 0,
      failedQuestions: 0,
      overallSuccessRate: 0.0,
      currentStreak: 0,
      longestStreak: 0,
      lastStudyDate: DateTime.now(),
      subjectStats: {},
      weeklyActivity: {},
      achievements: Achievement.defaultAchievements,
      dailyStats: {},
    );
  }

  /// Create a copy with updated fields
  StudentAnalytics copyWith({
    String? userId,
    int? totalQuestionsSolved,
    int? successfulQuestions,
    int? failedQuestions,
    double? overallSuccessRate,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastStudyDate,
    Map<String, SubjectStats>? subjectStats,
    Map<String, int>? weeklyActivity,
    List<Achievement>? achievements,
    Map<String, DailyStats>? dailyStats,
  }) {
    return StudentAnalytics(
      userId: userId ?? this.userId,
      totalQuestionsSolved: totalQuestionsSolved ?? this.totalQuestionsSolved,
      successfulQuestions: successfulQuestions ?? this.successfulQuestions,
      failedQuestions: failedQuestions ?? this.failedQuestions,
      overallSuccessRate: overallSuccessRate ?? this.overallSuccessRate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      subjectStats: subjectStats ?? this.subjectStats,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      achievements: achievements ?? this.achievements,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }

  /// Get unlocked achievements
  List<Achievement> get unlockedAchievements {
    return achievements.where((a) => a.isUnlocked).toList();
  }

  /// Get locked achievements
  List<Achievement> get lockedAchievements {
    return achievements.where((a) => !a.isUnlocked).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAnalytics &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() {
    return 'StudentAnalytics(userId: $userId, totalQuestions: $totalQuestionsSolved, successRate: ${(overallSuccessRate * 100).toStringAsFixed(1)}%, streak: $currentStreak)';
  }
}
