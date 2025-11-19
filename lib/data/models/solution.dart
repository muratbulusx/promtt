import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/enums.dart';
import 'solution_step.dart';

/// Solution data model for AI-generated question solutions
class Solution {
  final String solutionId;
  final String userId;
  final String examType;
  final String subject;
  final String topic;
  final DifficultyLevel difficultyLevel;
  final String problemDescription;
  final List<SolutionStep> stepByStepSolution;
  final String correctAnswer;
  final Map<String, String> optionAnalysis;
  final String topicExplanation;
  final List<String> examTips;
  final String? imageUrl;
  final DateTime createdAt;
  final int retryCount;
  final bool? isSuccessful; // null = not marked yet, true = correct, false = incorrect
  final double aiConfidence; // 0.0 - 1.0
  final String aiModel;
  final bool isFavorite;

  const Solution({
    required this.solutionId,
    required this.userId,
    required this.examType,
    required this.subject,
    required this.topic,
    required this.difficultyLevel,
    required this.problemDescription,
    required this.stepByStepSolution,
    required this.correctAnswer,
    required this.optionAnalysis,
    required this.topicExplanation,
    required this.examTips,
    this.imageUrl,
    required this.createdAt,
    this.retryCount = 0,
    this.isSuccessful,
    this.aiConfidence = 0.0,
    required this.aiModel,
    this.isFavorite = false,
  });

  /// Create Solution from Firestore document
  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      solutionId: json['solutionId'] as String,
      userId: json['userId'] as String,
      examType: json['examType'] as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      difficultyLevel: DifficultyLevel.fromString(json['difficultyLevel'] as String),
      problemDescription: json['problemDescription'] as String,
      stepByStepSolution: (json['stepByStepSolution'] as List)
          .map((step) => SolutionStep.fromJson(step as Map<String, dynamic>))
          .toList(),
      correctAnswer: json['correctAnswer'] as String,
      optionAnalysis: Map<String, String>.from(json['optionAnalysis'] as Map),
      topicExplanation: json['topicExplanation'] as String,
      examTips: List<String>.from(json['examTips'] as List),
      imageUrl: json['imageUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      retryCount: json['retryCount'] as int? ?? 0,
      isSuccessful: json['isSuccessful'] as bool?,
      aiConfidence: (json['aiConfidence'] as num?)?.toDouble() ?? 0.0,
      aiModel: json['aiModel'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// Convert Solution to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'solutionId': solutionId,
      'userId': userId,
      'examType': examType,
      'subject': subject,
      'topic': topic,
      'difficultyLevel': difficultyLevel.value,
      'problemDescription': problemDescription,
      'stepByStepSolution': stepByStepSolution.map((step) => step.toJson()).toList(),
      'correctAnswer': correctAnswer,
      'optionAnalysis': optionAnalysis,
      'topicExplanation': topicExplanation,
      'examTips': examTips,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'retryCount': retryCount,
      'isSuccessful': isSuccessful,
      'aiConfidence': aiConfidence,
      'aiModel': aiModel,
      'isFavorite': isFavorite,
    };
  }

  /// Create a copy with updated fields
  Solution copyWith({
    String? solutionId,
    String? userId,
    String? examType,
    String? subject,
    String? topic,
    DifficultyLevel? difficultyLevel,
    String? problemDescription,
    List<SolutionStep>? stepByStepSolution,
    String? correctAnswer,
    Map<String, String>? optionAnalysis,
    String? topicExplanation,
    List<String>? examTips,
    String? imageUrl,
    DateTime? createdAt,
    int? retryCount,
    bool? isSuccessful,
    double? aiConfidence,
    String? aiModel,
    bool? isFavorite,
  }) {
    return Solution(
      solutionId: solutionId ?? this.solutionId,
      userId: userId ?? this.userId,
      examType: examType ?? this.examType,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      problemDescription: problemDescription ?? this.problemDescription,
      stepByStepSolution: stepByStepSolution ?? this.stepByStepSolution,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      optionAnalysis: optionAnalysis ?? this.optionAnalysis,
      topicExplanation: topicExplanation ?? this.topicExplanation,
      examTips: examTips ?? this.examTips,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      isSuccessful: isSuccessful ?? this.isSuccessful,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      aiModel: aiModel ?? this.aiModel,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Get status text based on isSuccessful value
  String get statusText {
    if (isSuccessful == null) return 'Değerlendirilmedi';
    return isSuccessful! ? 'Doğru' : 'Yanlış';
  }

  /// Check if solution needs retry
  bool get needsRetry => isSuccessful == false && retryCount < 3;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Solution &&
          runtimeType == other.runtimeType &&
          solutionId == other.solutionId &&
          userId == other.userId;

  @override
  int get hashCode => solutionId.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'Solution(solutionId: $solutionId, subject: $subject, topic: $topic, difficultyLevel: ${difficultyLevel.displayName})';
  }
}
