import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enums.dart';

/// Study session model
class StudySession {
  final String sessionId;
  final String subject;
  final String topic;
  final int durationMinutes;
  final SessionType sessionType;
  final int targetQuestions;
  final String? bookReference;
  final String? chapterReference;
  final bool isCompleted;
  final DateTime? completedAt;
  final int actualQuestionsSolved;

  const StudySession({
    required this.sessionId,
    required this.subject,
    required this.topic,
    required this.durationMinutes,
    required this.sessionType,
    required this.targetQuestions,
    this.bookReference,
    this.chapterReference,
    this.isCompleted = false,
    this.completedAt,
    this.actualQuestionsSolved = 0,
  });

  /// Create StudySession from JSON
  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      sessionId: json['sessionId'] as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      durationMinutes: json['durationMinutes'] as int,
      sessionType: SessionType.fromString(json['sessionType'] as String),
      targetQuestions: json['targetQuestions'] as int,
      bookReference: json['bookReference'] as String?,
      chapterReference: json['chapterReference'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      actualQuestionsSolved: json['actualQuestionsSolved'] as int? ?? 0,
    );
  }

  /// Convert StudySession to JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'subject': subject,
      'topic': topic,
      'durationMinutes': durationMinutes,
      'sessionType': sessionType.value,
      'targetQuestions': targetQuestions,
      'bookReference': bookReference,
      'chapterReference': chapterReference,
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'actualQuestionsSolved': actualQuestionsSolved,
    };
  }

  /// Create a copy with updated fields
  StudySession copyWith({
    String? sessionId,
    String? subject,
    String? topic,
    int? durationMinutes,
    SessionType? sessionType,
    int? targetQuestions,
    String? bookReference,
    String? chapterReference,
    bool? isCompleted,
    DateTime? completedAt,
    int? actualQuestionsSolved,
  }) {
    return StudySession(
      sessionId: sessionId ?? this.sessionId,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      sessionType: sessionType ?? this.sessionType,
      targetQuestions: targetQuestions ?? this.targetQuestions,
      bookReference: bookReference ?? this.bookReference,
      chapterReference: chapterReference ?? this.chapterReference,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      actualQuestionsSolved: actualQuestionsSolved ?? this.actualQuestionsSolved,
    );
  }

  /// Get completion percentage based on questions solved
  double get completionPercentage {
    if (targetQuestions == 0) return 0.0;
    return (actualQuestionsSolved / targetQuestions).clamp(0.0, 1.0);
  }

  /// Check if target was met
  bool get targetMet {
    return actualQuestionsSolved >= targetQuestions;
  }

  /// Get session type icon
  String get sessionTypeIcon {
    switch (sessionType) {
      case SessionType.practice:
        return '📝';
      case SessionType.review:
        return '🔄';
      case SessionType.newTopic:
        return '🆕';
      case SessionType.weakTopic:
        return '💪';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySession &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId;

  @override
  int get hashCode => sessionId.hashCode;

  @override
  String toString() {
    return 'StudySession(sessionId: $sessionId, subject: $subject, topic: $topic, type: ${sessionType.displayName}, completed: $isCompleted)';
  }
}
