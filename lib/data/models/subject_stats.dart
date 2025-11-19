import 'package:cloud_firestore/cloud_firestore.dart';
import 'topic_performance.dart';

/// Subject-level statistics
class SubjectStats {
  final String subject;
  final int totalQuestions;
  final int correctAnswers;
  final double successRate;
  final List<String> strongTopics;
  final List<String> weakTopics;
  final Map<String, TopicPerformance> topicPerformance;
  final double averageDifficulty;
  final DateTime lastStudied;

  const SubjectStats({
    required this.subject,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.successRate,
    required this.strongTopics,
    required this.weakTopics,
    required this.topicPerformance,
    required this.averageDifficulty,
    required this.lastStudied,
  });

  /// Create SubjectStats from JSON
  factory SubjectStats.fromJson(Map<String, dynamic> json) {
    return SubjectStats(
      subject: json['subject'] as String,
      totalQuestions: json['totalQuestions'] as int? ?? 0,
      correctAnswers: json['correctAnswers'] as int? ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      strongTopics: List<String>.from(json['strongTopics'] as List? ?? []),
      weakTopics: List<String>.from(json['weakTopics'] as List? ?? []),
      topicPerformance: (json['topicPerformance'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              TopicPerformance.fromJson(value as Map<String, dynamic>),
            ),
          ) ??
          {},
      averageDifficulty: (json['averageDifficulty'] as num?)?.toDouble() ?? 0.0,
      lastStudied: json['lastStudied'] != null
          ? (json['lastStudied'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Convert SubjectStats to JSON
  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'successRate': successRate,
      'strongTopics': strongTopics,
      'weakTopics': weakTopics,
      'topicPerformance': topicPerformance.map((key, value) => MapEntry(key, value.toJson())),
      'averageDifficulty': averageDifficulty,
      'lastStudied': Timestamp.fromDate(lastStudied),
    };
  }

  /// Create empty subject stats
  factory SubjectStats.empty(String subject) {
    return SubjectStats(
      subject: subject,
      totalQuestions: 0,
      correctAnswers: 0,
      successRate: 0.0,
      strongTopics: [],
      weakTopics: [],
      topicPerformance: {},
      averageDifficulty: 0.0,
      lastStudied: DateTime.now(),
    );
  }

  /// Create a copy with updated fields
  SubjectStats copyWith({
    String? subject,
    int? totalQuestions,
    int? correctAnswers,
    double? successRate,
    List<String>? strongTopics,
    List<String>? weakTopics,
    Map<String, TopicPerformance>? topicPerformance,
    double? averageDifficulty,
    DateTime? lastStudied,
  }) {
    return SubjectStats(
      subject: subject ?? this.subject,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      successRate: successRate ?? this.successRate,
      strongTopics: strongTopics ?? this.strongTopics,
      weakTopics: weakTopics ?? this.weakTopics,
      topicPerformance: topicPerformance ?? this.topicPerformance,
      averageDifficulty: averageDifficulty ?? this.averageDifficulty,
      lastStudied: lastStudied ?? this.lastStudied,
    );
  }

  /// Get days since last studied
  int get daysSinceLastStudied {
    return DateTime.now().difference(lastStudied).inDays;
  }

  /// Check if subject is neglected (not studied in 7+ days)
  bool get isNeglected {
    return daysSinceLastStudied >= 7;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectStats && runtimeType == other.runtimeType && subject == other.subject;

  @override
  int get hashCode => subject.hashCode;

  @override
  String toString() {
    return 'SubjectStats(subject: $subject, totalQuestions: $totalQuestions, successRate: ${(successRate * 100).toStringAsFixed(1)}%)';
  }
}
