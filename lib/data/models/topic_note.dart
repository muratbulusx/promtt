import 'package:cloud_firestore/cloud_firestore.dart';

/// Topic note model for user notes
class TopicNote {
  final String noteId;
  final String userId;
  final String subject;
  final String topic;
  final String noteContent; // Markdown format
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final bool isPinned;
  final String? linkedSolutionId;

  const TopicNote({
    required this.noteId,
    required this.userId,
    required this.subject,
    required this.topic,
    required this.noteContent,
    this.imageUrls = const [],
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isPinned = false,
    this.linkedSolutionId,
  });

  /// Create TopicNote from Firestore document
  factory TopicNote.fromJson(Map<String, dynamic> json) {
    return TopicNote(
      noteId: json['noteId'] as String,
      userId: json['userId'] as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      noteContent: json['noteContent'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(json['tags'] as List? ?? []),
      isPinned: json['isPinned'] as bool? ?? false,
      linkedSolutionId: json['linkedSolutionId'] as String?,
    );
  }

  /// Convert TopicNote to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'userId': userId,
      'subject': subject,
      'topic': topic,
      'noteContent': noteContent,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
      'isPinned': isPinned,
      'linkedSolutionId': linkedSolutionId,
    };
  }

  /// Create a copy with updated fields
  TopicNote copyWith({
    String? noteId,
    String? userId,
    String? subject,
    String? topic,
    String? noteContent,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isPinned,
    String? linkedSolutionId,
  }) {
    return TopicNote(
      noteId: noteId ?? this.noteId,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      noteContent: noteContent ?? this.noteContent,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      linkedSolutionId: linkedSolutionId ?? this.linkedSolutionId,
    );
  }

  /// Check if note was recently updated (within 24 hours)
  bool get isRecentlyUpdated {
    return DateTime.now().difference(updatedAt).inHours < 24;
  }

  /// Check if note is linked to a solution
  bool get hasLinkedSolution {
    return linkedSolutionId != null && linkedSolutionId!.isNotEmpty;
  }

  /// Get word count of note content
  int get wordCount {
    return noteContent.trim().split(RegExp(r'\s+')).length;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicNote &&
          runtimeType == other.runtimeType &&
          noteId == other.noteId &&
          userId == other.userId;

  @override
  int get hashCode => noteId.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'TopicNote(noteId: $noteId, subject: $subject, topic: $topic, isPinned: $isPinned, wordCount: $wordCount)';
  }
}
