import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enums.dart';
import 'chapter.dart';

/// Book model for tracking textbook progress
class Book {
  final String bookId;
  final String userId;
  final String title;
  final String author;
  final String publisher;
  final String subject;
  final String? isbn;
  final String? coverImageUrl;
  final int totalPages;
  final int currentPage;
  final double progressPercentage;
  final List<Chapter> chapters;
  final DateTime startedAt;
  final DateTime? completedAt;
  final BookStatus status;
  final int questionsSolved;

  const Book({
    required this.bookId,
    required this.userId,
    required this.title,
    required this.author,
    required this.publisher,
    required this.subject,
    this.isbn,
    this.coverImageUrl,
    required this.totalPages,
    this.currentPage = 0,
    this.progressPercentage = 0.0,
    this.chapters = const [],
    required this.startedAt,
    this.completedAt,
    this.status = BookStatus.notStarted,
    this.questionsSolved = 0,
  });

  /// Create Book from Firestore document
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      subject: json['subject'] as String,
      isbn: json['isbn'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int? ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      chapters: (json['chapters'] as List?)
              ?.map((chapter) => Chapter.fromJson(chapter as Map<String, dynamic>))
              .toList() ??
          [],
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      status: BookStatus.fromString(json['status'] as String? ?? 'NOT_STARTED'),
      questionsSolved: json['questionsSolved'] as int? ?? 0,
    );
  }

  /// Convert Book to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'userId': userId,
      'title': title,
      'author': author,
      'publisher': publisher,
      'subject': subject,
      'isbn': isbn,
      'coverImageUrl': coverImageUrl,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'progressPercentage': progressPercentage,
      'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'status': status.value,
      'questionsSolved': questionsSolved,
    };
  }

  /// Create a copy with updated fields
  Book copyWith({
    String? bookId,
    String? userId,
    String? title,
    String? author,
    String? publisher,
    String? subject,
    String? isbn,
    String? coverImageUrl,
    int? totalPages,
    int? currentPage,
    double? progressPercentage,
    List<Chapter>? chapters,
    DateTime? startedAt,
    DateTime? completedAt,
    BookStatus? status,
    int? questionsSolved,
  }) {
    return Book(
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      subject: subject ?? this.subject,
      isbn: isbn ?? this.isbn,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      chapters: chapters ?? this.chapters,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      questionsSolved: questionsSolved ?? this.questionsSolved,
    );
  }

  /// Calculate progress percentage from current page
  double calculateProgress() {
    if (totalPages == 0) return 0.0;
    return (currentPage / totalPages).clamp(0.0, 1.0);
  }

  /// Get completed chapters count
  int get completedChaptersCount {
    return chapters.where((c) => c.isCompleted).length;
  }

  /// Get remaining pages
  int get remainingPages {
    return (totalPages - currentPage).clamp(0, totalPages);
  }

  /// Check if book is in progress
  bool get isInProgress {
    return status == BookStatus.inProgress || currentPage > 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          bookId == other.bookId &&
          userId == other.userId;

  @override
  int get hashCode => bookId.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'Book(bookId: $bookId, title: $title, author: $author, progress: ${(progressPercentage * 100).toStringAsFixed(1)}%)';
  }
}
