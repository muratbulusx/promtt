/// Difficulty levels for questions
enum DifficultyLevel {
  easy('EASY', 'Kolay'),
  medium('MEDIUM', 'Orta'),
  hard('HARD', 'Zor');

  final String value;
  final String displayName;

  const DifficultyLevel(this.value, this.displayName);

  static DifficultyLevel fromString(String value) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DifficultyLevel.medium,
    );
  }
}

/// Performance trend indicators
enum PerformanceTrend {
  improving('IMPROVING', 'Gelişiyor', '📈'),
  stable('STABLE', 'Sabit', '➡️'),
  declining('DECLINING', 'Düşüyor', '📉');

  final String value;
  final String displayName;
  final String icon;

  const PerformanceTrend(this.value, this.displayName, this.icon);

  static PerformanceTrend fromString(String value) {
    return PerformanceTrend.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PerformanceTrend.stable,
    );
  }
}

/// Book reading status
enum BookStatus {
  notStarted('NOT_STARTED', 'Başlanmadı'),
  inProgress('IN_PROGRESS', 'Devam Ediyor'),
  completed('COMPLETED', 'Tamamlandı');

  final String value;
  final String displayName;

  const BookStatus(this.value, this.displayName);

  static BookStatus fromString(String value) {
    return BookStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookStatus.notStarted,
    );
  }
}

/// Study session types
enum SessionType {
  practice('PRACTICE', 'Pratik'),
  review('REVIEW', 'Tekrar'),
  newTopic('NEW_TOPIC', 'Yeni Konu'),
  weakTopic('WEAK_TOPIC', 'Zayıf Konu');

  final String value;
  final String displayName;

  const SessionType(this.value, this.displayName);

  static SessionType fromString(String value) {
    return SessionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SessionType.practice,
    );
  }
}

/// AI model options
enum AIModel {
  gpt4('gpt-4', 'GPT-4'),
  gemini('gemini', 'Google Gemini');

  final String value;
  final String displayName;

  const AIModel(this.value, this.displayName);

  static AIModel fromString(String value) {
    return AIModel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AIModel.gpt4,
    );
  }
}

/// Detail level for AI solutions
enum DetailLevel {
  short('short', 'Kısa'),
  medium('medium', 'Orta'),
  detailed('detailed', 'Detaylı');

  final String value;
  final String displayName;

  const DetailLevel(this.value, this.displayName);

  static DetailLevel fromString(String value) {
    return DetailLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DetailLevel.medium,
    );
  }
}

/// Day of the week
enum DayOfWeek {
  monday('Monday', 'Pazartesi', 1),
  tuesday('Tuesday', 'Salı', 2),
  wednesday('Wednesday', 'Çarşamba', 3),
  thursday('Thursday', 'Perşembe', 4),
  friday('Friday', 'Cuma', 5),
  saturday('Saturday', 'Cumartesi', 6),
  sunday('Sunday', 'Pazar', 7);

  final String value;
  final String displayName;
  final int dayNumber;

  const DayOfWeek(this.value, this.displayName, this.dayNumber);

  static DayOfWeek fromString(String value) {
    return DayOfWeek.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DayOfWeek.monday,
    );
  }

  static DayOfWeek fromDateTime(DateTime date) {
    return DayOfWeek.values.firstWhere(
      (e) => e.dayNumber == date.weekday,
      orElse: () => DayOfWeek.monday,
    );
  }
}

/// Notification types
enum NotificationType {
  dailyReminder('DAILY_REMINDER', 'Günlük Hatırlatma'),
  solutionReady('SOLUTION_READY', 'Çözüm Hazır'),
  achievementUnlocked('ACHIEVEMENT_UNLOCKED', 'Başarı Kazanıldı'),
  weeklySummary('WEEKLY_SUMMARY', 'Haftalık Özet'),
  streakWarning('STREAK_WARNING', 'Streak Uyarısı'),
  studySessionReminder('STUDY_SESSION_REMINDER', 'Çalışma Hatırlatması');

  final String value;
  final String displayName;

  const NotificationType(this.value, this.displayName);

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NotificationType.dailyReminder,
    );
  }
}

/// Error types for logging
enum ErrorType {
  network('NETWORK', 'Ağ Hatası'),
  authentication('AUTHENTICATION', 'Kimlik Doğrulama Hatası'),
  aiProcessing('AI_PROCESSING', 'AI İşleme Hatası'),
  storage('STORAGE', 'Depolama Hatası'),
  dataValidation('DATA_VALIDATION', 'Veri Doğrulama Hatası'),
  unknown('UNKNOWN', 'Bilinmeyen Hata');

  final String value;
  final String displayName;

  const ErrorType(this.value, this.displayName);

  static ErrorType fromString(String value) {
    return ErrorType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ErrorType.unknown,
    );
  }
}
