import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enums.dart';

/// Topic-level performance tracking
class TopicPerformance {
  final String topic;
  final int attemptCount;
  final int successCount;
  final double successRate;
  final int retryCount;
  final DateTime lastAttempt;
  final PerformanceTrend trend;
  final List<DateTime> attemptDates;

  const TopicPerformance({
    required this.topic,
    required this.attemptCount,
    required this.successCount,
    required this.successRate,
    required this.retryCount,
    required this.lastAttempt,
    required this.trend,
    required this.attemptDates,
  });

  /// Create TopicPerformance from JSON
  factory TopicPerformance.fromJson(Map<String, dynamic> json) {
    return TopicPerformance(
      topic: json['topic'] as String,
      attemptCount: json['attemptCount'] as int? ?? 0,
      successCount: json['successCount'] as int? ?? 0,
      successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      retryCount: json['retryCount'] as int? ?? 0,
      lastAttempt: json['lastAttempt'] != null
          ? (json['lastAttempt'] as Timestamp).toDate()
          : DateTime.now(),
      trend: PerformanceTrend.fromString(json['trend'] as String? ?? 'STABLE'),
      attemptDates: (json['attemptDates'] as List?)
              ?.map((date) => (date as Timestamp).toDate())
              .toList() ??
          [],
    );
  }

  /// Convert TopicPerformance to JSON
  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'attemptCount': attemptCount,
      'successCount': successCount,
      'successRate': successRate,
      'retryCount': retryCount,
      'lastAttempt': Timestamp.fromDate(lastAttempt),
      'trend': trend.value,
      'attemptDates': attemptDates.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }

  /// Create empty topic performance
  factory TopicPerformance.empty(String topic) {
    return TopicPerformance(
      topic: topic,
      attemptCount: 0,
      successCount: 0,
      successRate: 0.0,
      retryCount: 0,
      lastAttempt: DateTime.now(),
      trend: PerformanceTrend.stable,
      attemptDates: [],
    );
  }

  /// Create a copy with updated fields
  TopicPerformance copyWith({
    String? topic,
    int? attemptCount,
    int? successCount,
    double? successRate,
    int? retryCount,
    DateTime? lastAttempt,
    PerformanceTrend? trend,
    List<DateTime>? attemptDates,
  }) {
    return TopicPerformance(
      topic: topic ?? this.topic,
      attemptCount: attemptCount ?? this.attemptCount,
      successCount: successCount ?? this.successCount,
      successRate: successRate ?? this.successRate,
      retryCount: retryCount ?? this.retryCount,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      trend: trend ?? this.trend,
      attemptDates: attemptDates ?? this.attemptDates,
    );
  }

  /// Get days since last attempt
  int get daysSinceLastAttempt {
    return DateTime.now().difference(lastAttempt).inDays;
  }

  /// Check if topic is weak (success rate < 60%)
  bool get isWeak {
    return attemptCount > 0 && successRate < 0.6;
  }

  /// Check if topic is strong (success rate > 80%)
  bool get isStrong {
    return attemptCount >= 3 && successRate > 0.8;
  }

  /// Check if topic is neglected (not attempted in 7+ days)
  bool get isNeglected {
    return attemptCount > 0 && daysSinceLastAttempt >= 7;
  }

  /// Calculate trend from recent attempts (last 5)
  static PerformanceTrend calculateTrend(List<bool> recentResults) {
    if (recentResults.length < 3) return PerformanceTrend.stable;

    // Calculate success rate for first half and second half
    final midPoint = recentResults.length ~/ 2;
    final firstHalf = recentResults.sublist(0, midPoint);
    final secondHalf = recentResults.sublist(midPoint);

    final firstHalfRate = firstHalf.where((r) => r).length / firstHalf.length;
    final secondHalfRate = secondHalf.where((r) => r).length / secondHalf.length;

    final difference = secondHalfRate - firstHalfRate;

    if (difference > 0.2) return PerformanceTrend.improving;
    if (difference < -0.2) return PerformanceTrend.declining;
    return PerformanceTrend.stable;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicPerformance && runtimeType == other.runtimeType && topic == other.topic;

  @override
  int get hashCode => topic.hashCode;

  @override
  String toString() {
    return 'TopicPerformance(topic: $topic, attempts: $attemptCount, successRate: ${(successRate * 100).toStringAsFixed(1)}%, trend: ${trend.displayName})';
  }
}
