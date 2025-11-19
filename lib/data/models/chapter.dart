import 'package:cloud_firestore/cloud_firestore.dart';

/// Chapter model for book chapters
class Chapter {
  final String chapterId;
  final String title;
  final int startPage;
  final int endPage;
  final List<String> topics;
  final bool isCompleted;
  final int questionsSolved;
  final DateTime? completedAt;
  final String? notes;

  const Chapter({
    required this.chapterId,
    required this.title,
    required this.startPage,
    required this.endPage,
    this.topics = const [],
    this.isCompleted = false,
    this.questionsSolved = 0,
    this.completedAt,
    this.notes,
  });

  /// Create Chapter from JSON
  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterId: json['chapterId'] as String,
      title: json['title'] as String,
      startPage: json['startPage'] as int,
      endPage: json['endPage'] as int,
      topics: List<String>.from(json['topics'] as List? ?? []),
      isCompleted: json['isCompleted'] as bool? ?? false,
      questionsSolved: json['questionsSolved'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      notes: json['notes'] as String?,
    );
  }

  /// Convert Chapter to JSON
  Map<String, dynamic> toJson() {
    return {
      'chapterId': chapterId,
      'title': title,
      'startPage': startPage,
      'endPage': endPage,
      'topics': topics,
      'isCompleted': isCompleted,
      'questionsSolved': questionsSolved,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'notes': notes,
    };
  }

  /// Create a copy with updated fields
  Chapter copyWith({
    String? chapterId,
    String? title,
    int? startPage,
    int? endPage,
    List<String>? topics,
    bool? isCompleted,
    int? questionsSolved,
    DateTime? completedAt,
    String? notes,
  }) {
    return Chapter(
      chapterId: chapterId ?? this.chapterId,
      title: title ?? this.title,
      startPage: startPage ?? this.startPage,
      endPage: endPage ?? this.endPage,
      topics: topics ?? this.topics,
      isCompleted: isCompleted ?? this.isCompleted,
      questionsSolved: questionsSolved ?? this.questionsSolved,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  /// Get total pages in chapter
  int get totalPages {
    return (endPage - startPage + 1).clamp(0, 9999);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chapter && runtimeType == other.runtimeType && chapterId == other.chapterId;

  @override
  int get hashCode => chapterId.hashCode;

  @override
  String toString() {
    return 'Chapter(chapterId: $chapterId, title: $title, pages: $startPage-$endPage, completed: $isCompleted)';
  }
}
