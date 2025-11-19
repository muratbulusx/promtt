import 'package:cloud_firestore/cloud_firestore.dart';
import 'daily_plan.dart';

/// Weekly study plan model
class WeeklyStudyPlan {
  final String planId;
  final String userId;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final Map<String, DailyPlan> dailyPlans; // "Monday", "Tuesday", ...
  final List<String> focusSubjects;
  final List<String> focusTopics;
  final String aiRecommendation;
  final bool isCustom;
  final DateTime createdAt;

  const WeeklyStudyPlan({
    required this.planId,
    required this.userId,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.dailyPlans,
    required this.focusSubjects,
    required this.focusTopics,
    required this.aiRecommendation,
    this.isCustom = false,
    required this.createdAt,
  });

  /// Create WeeklyStudyPlan from Firestore document
  factory WeeklyStudyPlan.fromJson(Map<String, dynamic> json) {
    return WeeklyStudyPlan(
      planId: json['planId'] as String,
      userId: json['userId'] as String,
      weekStartDate: (json['weekStartDate'] as Timestamp).toDate(),
      weekEndDate: (json['weekEndDate'] as Timestamp).toDate(),
      dailyPlans: (json['dailyPlans'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          DailyPlan.fromJson(value as Map<String, dynamic>),
        ),
      ),
      focusSubjects: List<String>.from(json['focusSubjects'] as List),
      focusTopics: List<String>.from(json['focusTopics'] as List),
      aiRecommendation: json['aiRecommendation'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert WeeklyStudyPlan to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'userId': userId,
      'weekStartDate': Timestamp.fromDate(weekStartDate),
      'weekEndDate': Timestamp.fromDate(weekEndDate),
      'dailyPlans': dailyPlans.map((key, value) => MapEntry(key, value.toJson())),
      'focusSubjects': focusSubjects,
      'focusTopics': focusTopics,
      'aiRecommendation': aiRecommendation,
      'isCustom': isCustom,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy with updated fields
  WeeklyStudyPlan copyWith({
    String? planId,
    String? userId,
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    Map<String, DailyPlan>? dailyPlans,
    List<String>? focusSubjects,
    List<String>? focusTopics,
    String? aiRecommendation,
    bool? isCustom,
    DateTime? createdAt,
  }) {
    return WeeklyStudyPlan(
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      dailyPlans: dailyPlans ?? this.dailyPlans,
      focusSubjects: focusSubjects ?? this.focusSubjects,
      focusTopics: focusTopics ?? this.focusTopics,
      aiRecommendation: aiRecommendation ?? this.aiRecommendation,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get total study minutes for the week
  int get totalStudyMinutes {
    return dailyPlans.values.fold(0, (sum, plan) => sum + plan.totalStudyMinutes);
  }

  /// Get total completed sessions
  int get totalCompletedSessions {
    return dailyPlans.values.fold(0, (sum, plan) => sum + plan.completedSessions);
  }

  /// Get total sessions
  int get totalSessions {
    return dailyPlans.values.fold(0, (sum, plan) => sum + plan.sessions.length);
  }

  /// Get overall completion percentage
  double get completionPercentage {
    if (totalSessions == 0) return 0.0;
    return totalCompletedSessions / totalSessions;
  }

  /// Check if week is current week
  bool get isCurrentWeek {
    final now = DateTime.now();
    return now.isAfter(weekStartDate) && now.isBefore(weekEndDate);
  }

  /// Check if week is in the past
  bool get isPastWeek {
    return DateTime.now().isAfter(weekEndDate);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyStudyPlan &&
          runtimeType == other.runtimeType &&
          planId == other.planId &&
          userId == other.userId;

  @override
  int get hashCode => planId.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'WeeklyStudyPlan(planId: $planId, week: ${weekStartDate.toString().split(' ')[0]} - ${weekEndDate.toString().split(' ')[0]}, completion: ${(completionPercentage * 100).toStringAsFixed(1)}%)';
  }
}
