/// Solution step model for step-by-step explanations
class SolutionStep {
  final int stepNumber;
  final String title;
  final String explanation;
  final String? formula; // LaTeX format
  final String? imageUrl;

  const SolutionStep({
    required this.stepNumber,
    required this.title,
    required this.explanation,
    this.formula,
    this.imageUrl,
  });

  /// Create SolutionStep from JSON
  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      formula: json['formula'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// Convert SolutionStep to JSON
  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'title': title,
      'explanation': explanation,
      'formula': formula,
      'imageUrl': imageUrl,
    };
  }

  /// Create a copy with updated fields
  SolutionStep copyWith({
    int? stepNumber,
    String? title,
    String? explanation,
    String? formula,
    String? imageUrl,
  }) {
    return SolutionStep(
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      formula: formula ?? this.formula,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolutionStep &&
          runtimeType == other.runtimeType &&
          stepNumber == other.stepNumber &&
          title == other.title;

  @override
  int get hashCode => stepNumber.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'SolutionStep(stepNumber: $stepNumber, title: $title)';
  }
}
