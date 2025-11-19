import '../../core/constants/app_constants.dart';

/// User settings and preferences
class UserSettings {
  final String aiModel; // "gpt-4" or "gemini"
  final String detailLevel; // "short", "medium", "detailed"
  final bool autoAddNotes;
  final bool showOptionAnalysis;
  final String language; // "tr" or "en"
  final bool darkMode;
  final int dailyGoal;
  final String notificationTime; // "20:00"
  final bool dailyReminder;
  final bool weeklyReport;
  final bool achievementNotifications;

  const UserSettings({
    required this.aiModel,
    required this.detailLevel,
    required this.autoAddNotes,
    required this.showOptionAnalysis,
    required this.language,
    required this.darkMode,
    required this.dailyGoal,
    required this.notificationTime,
    required this.dailyReminder,
    required this.weeklyReport,
    required this.achievementNotifications,
  });

  /// Create UserSettings from JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      aiModel: json['aiModel'] as String? ?? AppConstants.defaultAIModel,
      detailLevel: json['detailLevel'] as String? ?? AppConstants.defaultDetailLevel,
      autoAddNotes: json['autoAddNotes'] as bool? ?? false,
      showOptionAnalysis: json['showOptionAnalysis'] as bool? ?? true,
      language: json['language'] as String? ?? AppConstants.defaultLanguage,
      darkMode: json['darkMode'] as bool? ?? false,
      dailyGoal: json['dailyGoal'] as int? ?? AppConstants.defaultDailyGoal,
      notificationTime: json['notificationTime'] as String? ?? '20:00',
      dailyReminder: json['dailyReminder'] as bool? ?? true,
      weeklyReport: json['weeklyReport'] as bool? ?? true,
      achievementNotifications: json['achievementNotifications'] as bool? ?? true,
    );
  }

  /// Convert UserSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'aiModel': aiModel,
      'detailLevel': detailLevel,
      'autoAddNotes': autoAddNotes,
      'showOptionAnalysis': showOptionAnalysis,
      'language': language,
      'darkMode': darkMode,
      'dailyGoal': dailyGoal,
      'notificationTime': notificationTime,
      'dailyReminder': dailyReminder,
      'weeklyReport': weeklyReport,
      'achievementNotifications': achievementNotifications,
    };
  }

  /// Create default UserSettings
  factory UserSettings.defaults() {
    return const UserSettings(
      aiModel: AppConstants.defaultAIModel,
      detailLevel: AppConstants.defaultDetailLevel,
      autoAddNotes: false,
      showOptionAnalysis: true,
      language: AppConstants.defaultLanguage,
      darkMode: false,
      dailyGoal: AppConstants.defaultDailyGoal,
      notificationTime: '20:00',
      dailyReminder: true,
      weeklyReport: true,
      achievementNotifications: true,
    );
  }

  /// Create a copy with updated fields
  UserSettings copyWith({
    String? aiModel,
    String? detailLevel,
    bool? autoAddNotes,
    bool? showOptionAnalysis,
    String? language,
    bool? darkMode,
    int? dailyGoal,
    String? notificationTime,
    bool? dailyReminder,
    bool? weeklyReport,
    bool? achievementNotifications,
  }) {
    return UserSettings(
      aiModel: aiModel ?? this.aiModel,
      detailLevel: detailLevel ?? this.detailLevel,
      autoAddNotes: autoAddNotes ?? this.autoAddNotes,
      showOptionAnalysis: showOptionAnalysis ?? this.showOptionAnalysis,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      notificationTime: notificationTime ?? this.notificationTime,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      achievementNotifications: achievementNotifications ?? this.achievementNotifications,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettings &&
          runtimeType == other.runtimeType &&
          aiModel == other.aiModel &&
          detailLevel == other.detailLevel &&
          darkMode == other.darkMode &&
          language == other.language;

  @override
  int get hashCode =>
      aiModel.hashCode ^ detailLevel.hashCode ^ darkMode.hashCode ^ language.hashCode;

  @override
  String toString() {
    return 'UserSettings(aiModel: $aiModel, detailLevel: $detailLevel, language: $language, darkMode: $darkMode, dailyGoal: $dailyGoal)';
  }
}
