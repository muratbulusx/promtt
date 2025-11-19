import 'package:cloud_firestore/cloud_firestore.dart';

/// Daily statistics for activity tracking
class DailyStats {
  final String date; // "2024-11-19"
  final int questionsAttempted;
  final int questionsCorrect;
  final int questionsIncorrect;
  final double successRate;
  final int studyMinutes;
  final List<String> subjectsStudied;
  final DateTime timestamp;

  const DailyStats({
    required this.date,
    required this.questionsAttempted,
    required this.questionsCorrect,
    required this.questionsIncorrect,
    required this.successRate,
    required this.studyMinutes,
    required this.subjectsStudied,
    required this.timestamp,
  });

  /// Create DailyStats from JSON
  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: json['date'] as String,
      questionsAttempted: json['questionsAttempted'] as int? ?? 0,
      questionsCorrect: json['questionsCorrect'] as int? ?? 0,
      questionsIncorrect: json['questionsIncorrect'] as int? ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      studyMinutes: json['studyMinutes'] as int? ?? 0,
      subjectsStudied: List<String>.from(json['subjectsStudied'] as List? ?? []),
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Convert DailyStats to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'questionsAttempted': questionsAttempted,
      'questionsCorrect': questionsCorrect,
      'questionsIncorrect': questionsIncorrect,
      'successRate': successRate,
      'studyMinutes': studyMinutes,
      'subjectsStudied': subjectsStudied,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  /// Create empty daily stats
  factory DailyStats.empty(String date) {
    return DailyStats(
      date: date,
      questionsAttempted: 0,
      questionsCorrect: 0,
      questionsIncorrect: 0,
      successRate: 0.0,
      studyMinutes: 0,
      subjectsStudied: [],
      timestamp: DateTime.now(),
    );
  }

  /// Create a copy with updated fields
  DailyStats copyWith({
    String? date,
    int? questionsAttempted,
    int? questionsCorrect,
    int? questionsIncorrect,
    double? successRate,
    int? studyMinutes,
    List<String>? subjectsStudied,
    DateTime? timestamp,
  }) {
    return DailyStats(
      date: date ?? this.date,
      questionsAttempted: questionsAttempted ?? this.questionsAttempted,
      questionsCorrect: questionsCorrect ?? this.questionsCorrect,
      questionsIncorrect: questionsIncorrect ?? this.questionsIncorrect,
      successRate: successRate ?? this.successRate,
      studyMinutes: studyMinutes ?? this.studyMinutes,
      subjectsStudied: subjectsStudied ?? this.subjectsStudied,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Get activity level based on questions attempted
  String get activityLevel {
    if (questionsAttempted == 0) return 'none';
    if (questionsAttempted < 5) return 'low';
    if (questionsAttempted < 10) return 'medium';
    return 'high';
  }

  /// Check if daily goal was met (assuming default goal of 10)
  bool hasMetGoal(int dailyGoal) {
    return questionsAttempted >= dailyGoal;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStats && runtimeType == other.runtimeType && date == other.date;

  @override
  int get hashCode => date.hashCode;

  @override
  String toString() {
    return 'DailyStats(date: $date, attempted: $questionsAttempted, correct: $questionsCorrect, successRate: ${(successRate * 100).toStringAsFixed(1)}%)';
  }
}
