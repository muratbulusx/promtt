/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Limoncuk Eğitim';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String solutionsCollection = 'solutions';
  static const String analyticsCollection = 'analytics';
  static const String studyPlansCollection = 'studyPlans';
  static const String booksCollection = 'books';
  static const String topicNotesCollection = 'topicNotes';
  static const String adminUsersCollection = 'adminUsers';
  static const String errorLogsCollection = 'errorLogs';

  // Firebase Storage Paths
  static const String profilePhotosPath = 'profile_photos';
  static const String questionImagesPath = 'question_images';
  static const String bookCoversPath = 'book_covers';
  static const String noteImagesPath = 'note_images';

  // Cloud Functions
  static const String analyzeSolutionFunction = 'analyzeSolutionWithAI';
  static const String generateWeeklyPlanFunction = 'generateWeeklyPlan';
  static const String updateAnalyticsFunction = 'updateAnalytics';

  // Image Constraints
  static const int maxProfilePhotoSizeMB = 5;
  static const int maxQuestionImageSizeMB = 20;
  static const int maxNoteImageSizeMB = 10;
  static const double imageQuality = 0.85;
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1920;

  // AI Settings
  static const int maxAIRetries = 3;
  static const int aiTimeoutSeconds = 60;
  static const double minAIConfidence = 0.5;

  // Analytics Thresholds
  static const double weakTopicThreshold = 0.6; // 60%
  static const double strongTopicThreshold = 0.8; // 80%
  static const int trendAnalysisAttempts = 5;
  static const int neglectedTopicDays = 7;

  // Study Plan
  static const int planAnalysisDays = 14;
  static const int maxSessionsPerDay = 4;
  static const int minSessionDurationMinutes = 15;
  static const int maxSessionDurationMinutes = 120;

  // Notifications
  static const int dailyReminderHour = 20; // 20:00
  static const int dailyReminderMinute = 0;
  static const int streakWarningHour = 23; // 23:00
  static const int streakWarningMinute = 0;
  static const int weeklyReportDay = 7; // Sunday
  static const int weeklyReportHour = 21; // 21:00
  static const int weeklyReportMinute = 0;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Cache
  static const int cacheExpirationDays = 7;
  static const int maxCacheSizeMB = 200;

  // SharedPreferences Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String lastSyncTimeKey = 'last_sync_time';

  // Exam Types
  static const List<String> examTypes = [
    'İlkokul 1',
    'İlkokul 2',
    'İlkokul 3',
    'İlkokul 4',
    'Ortaokul 5',
    'Ortaokul 6',
    'Ortaokul 7',
    'Ortaokul 8',
    'LGS',
    'Lise 9',
    'Lise 10',
    'Lise 11',
    'Lise 12',
    'YKS-TYT',
    'YKS-AYT',
    'KPSS',
    'ALES',
    'DGS',
  ];

  // Subjects
  static const List<String> mathSubjects = [
    'Matematik',
    'Geometri',
  ];

  static const List<String> scienceSubjects = [
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Fen Bilimleri',
  ];

  static const List<String> socialSubjects = [
    'Tarih',
    'Coğrafya',
    'Felsefe',
    'Din Kültürü',
  ];

  static const List<String> languageSubjects = [
    'Türkçe',
    'İngilizce',
    'Edebiyat',
  ];

  static const List<String> allSubjects = [
    ...mathSubjects,
    ...scienceSubjects,
    ...socialSubjects,
    ...languageSubjects,
  ];

  // Achievement Milestones
  static const Map<String, int> achievementMilestones = {
    'first_question': 1,
    'beginner': 10,
    'intermediate': 50,
    'advanced': 100,
    'expert': 250,
    'master': 500,
    'grandmaster': 1000,
    'streak_3': 3,
    'streak_7': 7,
    'streak_30': 30,
    'streak_100': 100,
    'perfect_subject': 100, // 100% success in a subject
  };

  // Default Values
  static const int defaultDailyGoal = 10;
  static const String defaultAIModel = 'gpt-4';
  static const String defaultDetailLevel = 'medium';
  static const String defaultLanguage = 'tr';
  static const int defaultStudyDurationMinutes = 30;
}
