import 'study_session.dart';

/// Daily study plan model
class DailyPlan {
  final String day; // "Monday", "Tuesday", etc.
  final String dayTR; // Turkish translation
  final List<StudySession> sessions;
  final int totalStudyMinutes;
  final bool isCompleted;
  final int completedSessions;

  const DailyPlan({
    required this.day,
    required this.dayTR,
    required this.sessions,
    required this.totalStudyMinutes,
    this.isCompleted = false,
    this.completedSessions = 0,
  });

  /// Create DailyPlan from JSON
  factory DailyPlan.fromJson(Map<String, dynamic> json) {
    return DailyPlan(
      day: json['day'] as String,
      dayTR: json['dayTR'] as String,
      sessions: (json['sessions'] as List)
          .map((session) => StudySession.fromJson(session as Map<String, dynamic>))
          .toList(),
      totalStudyMinutes: json['totalStudyMinutes'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedSessions: json['completedSessions'] as int? ?? 0,
    );
  }

  /// Convert DailyPlan to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'dayTR': dayTR,
      'sessions': sessions.map((session) => session.toJson()).toList(),
      'totalStudyMinutes': totalStudyMinutes,
      'isCompleted': isCompleted,
      'completedSessions': completedSessions,
    };
  }

  /// Create empty daily plan
  factory DailyPlan.empty(String day, String dayTR) {
    return DailyPlan(
      day: day,
      dayTR: dayTR,
      sessions: [],
      totalStudyMinutes: 0,
      isCompleted: false,
      completedSessions: 0,
    );
  }

  /// Create a copy with updated fields
  DailyPlan copyWith({
    String? day,
    String? dayTR,
    List<StudySession>? sessions,
    int? totalStudyMinutes,
    bool? isCompleted,
    int? completedSessions,
  }) {
    return DailyPlan(
      day: day ?? this.day,
      dayTR: dayTR ?? this.dayTR,
      sessions: sessions ?? this.sessions,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }

  /// Get completion percentage
  double get completionPercentage {
    if (sessions.isEmpty) return 0.0;
    return completedSessions / sessions.length;
  }

  /// Get pending sessions
  List<StudySession> get pendingSessions {
    return sessions.where((s) => !s.isCompleted).toList();
  }

  /// Get completed sessions list
  List<StudySession> get completedSessionsList {
    return sessions.where((s) => s.isCompleted).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPlan && runtimeType == other.runtimeType && day == other.day;

  @override
  int get hashCode => day.hashCode;

  @override
  String toString() {
    return 'DailyPlan(day: $dayTR, sessions: ${sessions.length}, completed: $completedSessions/${sessions.length})';
  }
}
