# Design Document

## Overview

Limoncuk Eğitim is a Flutter-based mobile application that leverages Firebase as its backend infrastructure and integrates with AI services (OpenAI GPT-4 and Google Gemini) for intelligent question solving. The application follows a clean architecture pattern with clear separation between presentation, business logic, and data layers. The system is designed for scalability, offline-first capabilities, and optimal performance on both iOS and Android platforms.

### Key Design Principles

1. **Unlimited Free Usage**: No credit system or payment walls - all features are completely free
2. **AI-First Approach**: Every question receives full AI analysis without restrictions
3. **Offline-First**: Critical features work without internet connectivity
4. **Performance**: Fast response times with optimized image processing and caching
5. **Security**: User data protection with Firebase Security Rules and encrypted communication
6. **Scalability**: Cloud Functions handle AI processing to support growing user base
7. **User Experience**: Intuitive interface with smooth animations and responsive feedback

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Presentation │  │   Business   │  │     Data     │      │
│  │    Layer     │──│     Logic    │──│    Layer     │      │
│  │   (Screens)  │  │  (Providers) │  │(Repositories)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Services                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │     Auth     │  │   Firestore  │  │   Storage    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │   Functions  │  │  Messaging   │                         │
│  └──────────────┘  └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      AI Services                             │
│         ┌──────────────┐      ┌──────────────┐             │
│         │   OpenAI     │      │    Gemini    │             │
│         │    GPT-4     │      │              │             │
│         └──────────────┘      └──────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

**Presentation Layer**
- UI components and screens
- User input handling
- Navigation management
- State rendering

**Business Logic Layer**
- State management (Provider)
- Business rules and validation
- Data transformation
- Event handling

**Data Layer**
- Repository pattern for data access
- Firebase service wrappers
- Local caching (SharedPreferences, Hive)
- API communication


## Components and Interfaces

### Core Components

#### 1. Authentication Module

**Components:**
- `AuthService`: Firebase Authentication wrapper
- `AuthRepository`: Authentication data operations
- `AuthProvider`: State management for auth state
- `LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen`: UI screens

**Key Interfaces:**
```dart
abstract class IAuthService {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Stream<User?> get authStateChanges;
}
```

**Design Decisions:**
- Use Firebase Authentication for security and reliability
- Support multiple auth providers (Email, Google, Apple)
- Stream-based auth state for reactive UI updates
- Automatic token refresh handled by Firebase SDK

#### 2. Question Solving Module

**Components:**
- `CameraService`: Camera and image capture
- `ImageProcessingService`: Image editing and optimization
- `SolutionService`: AI integration and solution management
- `SolutionRepository`: Firestore operations for solutions
- `SolutionProvider`: State management for solving flow

**Key Interfaces:**
```dart
abstract class ISolutionService {
  Future<String> uploadQuestionImage(File image, String userId);
  Future<Solution> analyzeSolution({
    required String imageUrl,
    required String examType,
    required String subject,
    String? topic,
    String? aiModel,
    int retryCount = 0,
  });
  Future<void> markSolutionCorrect(String solutionId);
  Future<void> retrySolution(String solutionId);
  Stream<List<Solution>> getUserSolutions(String userId);
}
```

**AI Integration Flow:**
```
User captures photo → Image optimization → Upload to Storage →
Generate signed URL → Call Cloud Function → 
Cloud Function calls AI API → Parse AI response →
Store in Firestore → Update Analytics → Notify user
```

**Design Decisions:**
- Cloud Functions handle AI calls to protect API keys
- Image optimization before upload (resize, compress)
- Retry mechanism with modified prompts for incorrect solutions
- Support for both GPT-4 and Gemini with user preference
- LaTeX formula rendering using flutter_math_fork
- Markdown support for formatted text

#### 3. Analytics Module

**Components:**
- `AnalyticsService`: Calculation and aggregation logic
- `AnalyticsRepository`: Firestore operations
- `AnalyticsProvider`: State management
- `StatsScreen`, `SubjectDetailScreen`, `TopicDetailScreen`: UI screens

**Key Interfaces:**
```dart
abstract class IAnalyticsService {
  Future<StudentAnalytics> getUserAnalytics(String userId);
  Future<void> updateAnalyticsAfterQuestion({
    required String userId,
    required String subject,
    required String topic,
    required bool isCorrect,
  });
  Future<void> updateStreak(String userId);
  Future<List<Achievement>> checkAndUnlockAchievements(String userId);
  Map<String, double> calculateSubjectDistribution(StudentAnalytics analytics);
  List<String> identifyWeakTopics(Map<String, TopicPerformance> topics);
  List<String> identifyStrongTopics(Map<String, TopicPerformance> topics);
}
```

**Analytics Calculations:**
- Success rate: `successfulQuestions / totalQuestions`
- Streak: Consecutive days with at least 1 question solved
- Trend: Linear regression on last 5 attempts
- Weak topics: Success rate < 60%
- Strong topics: Success rate > 80%

**Design Decisions:**
- Real-time analytics updates using Firestore listeners
- Efficient aggregation with Firestore transactions
- Client-side calculations for UI responsiveness
- Server-side validation for critical metrics
- Achievement system with progressive milestones

#### 4. Study Plan Module

**Components:**
- `StudyPlanService`: AI-powered plan generation
- `StudyPlanRepository`: Firestore operations
- `StudyPlanProvider`: State management
- `StudyPlanScreen`: UI screen

**Key Interfaces:**
```dart
abstract class IStudyPlanService {
  Future<WeeklyStudyPlan> generateWeeklyPlan({
    required String userId,
    required DateTime weekStartDate,
    required StudyPreferences preferences,
  });
  Future<void> completeSession(String planId, String sessionId);
  Future<void> updateSessionProgress(String planId, String sessionId, int questionsSolved);
  Stream<WeeklyStudyPlan> getCurrentWeekPlan(String userId);
}
```

**Plan Generation Algorithm:**
```
1. Fetch user analytics for last 14 days
2. Identify weak topics (success rate < 60%)
3. Identify neglected topics (not studied in 7+ days)
4. Calculate priority scores:
   - Weak topics: priority = (1 - successRate) * 2
   - Neglected topics: priority = daysSinceLastStudy / 7
   - High retry count: priority += retryCount * 0.1
5. Distribute sessions across weekdays based on daily study duration
6. Balance subjects (no more than 2 sessions of same subject per day)
7. Include review sessions on weekends
8. Generate AI recommendation using GPT-4/Gemini
```

**Design Decisions:**
- Weekly planning cycle (Monday to Sunday)
- AI-generated recommendations for motivation
- Flexible session completion tracking
- Integration with notification system for reminders
- Manual customization allowed


#### 5. Library Module

**Components:**
- `BookService`: Book management and progress tracking
- `NoteService`: Topic notes management
- `BookRepository`, `NoteRepository`: Firestore operations
- `LibraryProvider`: State management
- `BooksScreen`, `NotesScreen`, `SolutionsScreen`: UI screens

**Key Interfaces:**
```dart
abstract class IBookService {
  Future<Book> addBook(Book book);
  Future<void> updateBookProgress(String bookId, int currentPage);
  Future<void> completeChapter(String bookId, String chapterId);
  Future<Book?> scanBookBarcode(String isbn);
  Stream<List<Book>> getUserBooks(String userId);
}

abstract class INoteService {
  Future<TopicNote> createNote(TopicNote note);
  Future<void> updateNote(String noteId, String content);
  Future<void> pinNote(String noteId, bool isPinned);
  Future<List<TopicNote>> searchNotes(String userId, String query);
  Stream<List<TopicNote>> getUserNotes(String userId);
}
```

**Design Decisions:**
- Barcode scanning using mobile_scanner package
- Markdown editor with LaTeX support for notes
- Auto-generated notes from AI solutions (optional)
- Image attachments stored in Firebase Storage
- Full-text search using Firestore queries
- Pinned notes displayed at top

#### 6. Admin Module

**Components:**
- `AdminService`: Admin operations and analytics
- `AdminRepository`: Firestore operations with admin privileges
- `AdminProvider`: State management
- `AdminDashboardScreen`, `UsersScreen`, `ReportsScreen`: UI screens

**Key Interfaces:**
```dart
abstract class IAdminService {
  Future<bool> isAdmin(String userId);
  Future<AdminDashboard> getDashboardData();
  Future<List<UserProfile>> searchUsers(String query);
  Future<UserDetailData> getUserDetail(String userId);
  Future<void> banUser(String userId, String reason);
  Future<void> unbanUser(String userId);
  Future<Report> generateReport(DateTime startDate, DateTime endDate);
}
```

**Admin Access Control:**
- Admin status stored in separate `adminUsers` collection
- Firestore Security Rules enforce admin-only access
- Admin UI only visible to authorized users
- Audit logging for admin actions

**Design Decisions:**
- Separate admin module for security isolation
- Read-only access to user data (no modification except ban)
- Comprehensive reporting with export capabilities
- Real-time dashboard updates

#### 7. Notification Module

**Components:**
- `NotificationService`: FCM integration and local notifications
- `NotificationScheduler`: Scheduled notification management
- `NotificationHandler`: Deep linking and action handling

**Key Interfaces:**
```dart
abstract class INotificationService {
  Future<void> initialize();
  Future<String?> getFCMToken();
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  });
  Future<void> cancelNotification(int notificationId);
  Stream<RemoteMessage> get onMessageReceived;
}
```

**Notification Types:**
1. Daily reminder (scheduled locally)
2. Solution ready (push from Cloud Function)
3. Achievement unlocked (push from Cloud Function)
4. Weekly summary (scheduled Cloud Function)
5. Streak warning (scheduled locally)
6. Study session reminder (scheduled locally)

**Design Decisions:**
- Firebase Cloud Messaging for push notifications
- flutter_local_notifications for local scheduling
- Deep linking to specific screens
- User preferences for notification types
- Timezone-aware scheduling

## Data Models

### Core Data Models

#### UserProfile
```dart
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String studentClass; // "İlkokul 4", "Lise 11", "YKS", "KPSS"
  final List<String> examTypes; // ["YKS-TYT", "YKS-AYT"]
  final List<String> subjects; // ["Matematik", "Fizik"]
  final DateTime createdAt;
  final DateTime lastActive;
  final UserSettings settings;
  
  // Firestore serialization
  Map<String, dynamic> toJson();
  factory UserProfile.fromJson(Map<String, dynamic> json);
}

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
}
```

#### Solution
```dart
class Solution {
  final String solutionId;
  final String userId;
  final String examType;
  final String subject;
  final String topic;
  final DifficultyLevel difficultyLevel; // EASY, MEDIUM, HARD
  final String problemDescription;
  final List<SolutionStep> stepByStepSolution;
  final String correctAnswer;
  final Map<String, String> optionAnalysis;
  final String topicExplanation;
  final List<String> examTips;
  final String? imageUrl;
  final DateTime createdAt;
  final int retryCount;
  final bool? isSuccessful; // null = not marked yet
  final double aiConfidence; // 0.0 - 1.0
  final String aiModel;
  final bool isFavorite;
  
  Map<String, dynamic> toJson();
  factory Solution.fromJson(Map<String, dynamic> json);
}

class SolutionStep {
  final int stepNumber;
  final String title;
  final String explanation;
  final String? formula; // LaTeX format
  final String? imageUrl;
}
```

#### StudentAnalytics
```dart
class StudentAnalytics {
  final String userId;
  final int totalQuestionsSolved;
  final int successfulQuestions;
  final int failedQuestions;
  final double overallSuccessRate;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastStudyDate;
  final Map<String, SubjectStats> subjectStats;
  final Map<String, int> weeklyActivity; // "2024-11-19": 15
  final List<Achievement> achievements;
  final Map<String, DailyStats> dailyStats;
  
  Map<String, dynamic> toJson();
  factory StudentAnalytics.fromJson(Map<String, dynamic> json);
}

class SubjectStats {
  final String subject;
  final int totalQuestions;
  final int correctAnswers;
  final double successRate;
  final List<String> strongTopics;
  final List<String> weakTopics;
  final Map<String, TopicPerformance> topicPerformance;
  final double averageDifficulty;
  final DateTime lastStudied;
}

class TopicPerformance {
  final String topic;
  final int attemptCount;
  final int successCount;
  final double successRate;
  final int retryCount;
  final DateTime lastAttempt;
  final PerformanceTrend trend; // IMPROVING, STABLE, DECLINING
  final List<DateTime> attemptDates;
}
```

#### WeeklyStudyPlan
```dart
class WeeklyStudyPlan {
  final String planId;
  final String userId;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final Map<String, DailyPlan> dailyPlans; // "Monday", "Tuesday", ...
  final List<String> focusSubjects;
  final List<String> focusTopics;
  final String aiRecommendation;
  final bool isCustom;
  final DateTime createdAt;
  
  Map<String, dynamic> toJson();
  factory WeeklyStudyPlan.fromJson(Map<String, dynamic> json);
}

class DailyPlan {
  final String day;
  final String dayTR;
  final List<StudySession> sessions;
  final int totalStudyMinutes;
  final bool isCompleted;
  final int completedSessions;
}

class StudySession {
  final String sessionId;
  final String subject;
  final String topic;
  final int durationMinutes;
  final SessionType sessionType; // PRACTICE, REVIEW, NEW_TOPIC, WEAK_TOPIC
  final int targetQuestions;
  final String? bookReference;
  final String? chapterReference;
  final bool isCompleted;
  final DateTime? completedAt;
  final int actualQuestionsSolved;
}
```

#### Book
```dart
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
  final BookStatus status; // NOT_STARTED, IN_PROGRESS, COMPLETED
  final int questionsSolved;
  
  Map<String, dynamic> toJson();
  factory Book.fromJson(Map<String, dynamic> json);
}

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
}
```

#### TopicNote
```dart
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
  
  Map<String, dynamic> toJson();
  factory TopicNote.fromJson(Map<String, dynamic> json);
}
```


## Error Handling

### Error Categories

#### 1. Network Errors
- **Scenario**: No internet connection, timeout, server unavailable
- **Handling**: 
  - Display user-friendly error message
  - Enable offline mode for cached data
  - Queue operations for retry when connection restored
  - Show retry button for critical operations

#### 2. Authentication Errors
- **Scenario**: Invalid credentials, expired token, account disabled
- **Handling**:
  - Display specific error messages (wrong password, user not found)
  - Redirect to login screen for expired sessions
  - Provide password reset option
  - Log errors for admin review

#### 3. AI Processing Errors
- **Scenario**: AI API timeout, invalid response, quota exceeded
- **Handling**:
  - Retry with exponential backoff (max 3 attempts)
  - Switch to alternative AI model if available
  - Notify user of processing failure
  - Store failed request for manual review
  - Refund credits (N/A - unlimited usage)

#### 4. Storage Errors
- **Scenario**: Upload failure, insufficient storage, file too large
- **Handling**:
  - Validate file size before upload (max 20MB for questions)
  - Compress images automatically
  - Display progress indicator during upload
  - Allow retry with smaller file size

#### 5. Data Validation Errors
- **Scenario**: Invalid input, missing required fields
- **Handling**:
  - Real-time validation with inline error messages
  - Prevent form submission until valid
  - Clear error messages explaining requirements
  - Highlight invalid fields

### Error Logging Strategy

```dart
class ErrorLogger {
  static Future<void> logError({
    required String errorType,
    required String message,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) async {
    // Log to Firebase Crashlytics
    await FirebaseCrashlytics.instance.recordError(
      message,
      stackTrace,
      reason: errorType,
    );
    
    // Log to Firestore for admin review (critical errors only)
    if (isCriticalError(errorType)) {
      await FirebaseFirestore.instance.collection('errorLogs').add({
        'errorType': errorType,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'additionalData': additionalData,
      });
    }
  }
}
```

### Retry Mechanisms

**Exponential Backoff for AI Requests:**
```dart
Future<Solution> analyzeSolutionWithRetry(SolutionRequest request) async {
  int attempts = 0;
  const maxAttempts = 3;
  const baseDelay = Duration(seconds: 2);
  
  while (attempts < maxAttempts) {
    try {
      return await _callAIService(request);
    } catch (e) {
      attempts++;
      if (attempts >= maxAttempts) rethrow;
      
      final delay = baseDelay * pow(2, attempts - 1);
      await Future.delayed(delay);
    }
  }
  throw Exception('Max retry attempts exceeded');
}
```

## Testing Strategy

### Unit Testing

**Target Coverage: 80%+**

**Test Categories:**
1. **Model Tests**: Serialization/deserialization, validation
2. **Service Tests**: Business logic, calculations, data transformations
3. **Repository Tests**: Data access operations (mocked Firestore)
4. **Provider Tests**: State management logic

**Example Test Structure:**
```dart
// test/services/analytics_service_test.dart
group('AnalyticsService', () {
  late AnalyticsService service;
  late MockAnalyticsRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAnalyticsRepository();
    service = AnalyticsService(mockRepository);
  });
  
  test('calculateSuccessRate returns correct percentage', () {
    final rate = service.calculateSuccessRate(80, 100);
    expect(rate, 0.8);
  });
  
  test('identifyWeakTopics filters topics below threshold', () {
    final topics = {
      'Türev': TopicPerformance(successRate: 0.92),
      'İntegral': TopicPerformance(successRate: 0.45),
      'Geometri': TopicPerformance(successRate: 0.88),
    };
    
    final weakTopics = service.identifyWeakTopics(topics);
    expect(weakTopics, contains('İntegral'));
    expect(weakTopics, isNot(contains('Türev')));
  });
  
  test('updateStreak increments when last study was yesterday', () async {
    final analytics = StudentAnalytics(
      currentStreak: 5,
      lastStudyDate: DateTime.now().subtract(Duration(days: 1)),
    );
    
    when(mockRepository.getAnalytics(any)).thenAnswer((_) async => analytics);
    
    await service.updateStreak('user123');
    
    verify(mockRepository.updateAnalytics(
      argThat(predicate((a) => a.currentStreak == 6))
    )).called(1);
  });
});
```

### Widget Testing

**Target Coverage: 60%+**

**Test Categories:**
1. **Screen Tests**: Widget rendering, user interactions
2. **Component Tests**: Custom widgets, buttons, cards
3. **Navigation Tests**: Route transitions, deep linking

**Example Test:**
```dart
// test/widgets/solution_card_test.dart
testWidgets('SolutionCard displays all solution details', (tester) async {
  final mockSolution = Solution(
    subject: 'Matematik',
    topic: 'Türev',
    correctAnswer: 'C',
    difficultyLevel: DifficultyLevel.MEDIUM,
    stepByStepSolution: [
      SolutionStep(stepNumber: 1, title: 'Adım 1', explanation: 'Test'),
    ],
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SolutionCard(solution: mockSolution),
      ),
    ),
  );
  
  expect(find.text('Matematik'), findsOneWidget);
  expect(find.text('Türev'), findsOneWidget);
  expect(find.text('C'), findsOneWidget);
  expect(find.text('Adım 1'), findsOneWidget);
});
```

### Integration Testing

**Test Scenarios:**
1. **Complete Question Solving Flow**: Login → Camera → Capture → Select exam/subject → Submit → View solution
2. **Analytics Update Flow**: Solve question → Mark correct/incorrect → Verify analytics update
3. **Study Plan Flow**: Generate plan → View sessions → Complete session → Verify progress
4. **Offline Mode Flow**: Disconnect → View cached data → Reconnect → Verify sync

**Example Test:**
```dart
// integration_test/question_solving_test.dart
testWidgets('Complete question solving flow', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Login
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');
  await tester.enterText(find.byKey(Key('password')), 'password123');
  await tester.tap(find.text('Giriş Yap'));
  await tester.pumpAndSettle();
  
  // Navigate to solve screen
  await tester.tap(find.byIcon(Icons.camera_alt));
  await tester.pumpAndSettle();
  
  // Select exam type
  await tester.tap(find.text('YKS-TYT'));
  await tester.pumpAndSettle();
  
  // Select subject
  await tester.tap(find.text('Matematik'));
  await tester.pumpAndSettle();
  
  // Verify camera screen loaded
  expect(find.byType(CameraPreview), findsOneWidget);
});
```

### Performance Testing

**Metrics to Monitor:**
1. **App Launch Time**: < 3 seconds cold start
2. **Screen Transition Time**: < 300ms
3. **Image Upload Time**: < 5 seconds for 5MB image
4. **AI Response Time**: < 15 seconds average
5. **Firestore Query Time**: < 1 second for typical queries
6. **Memory Usage**: < 200MB average
7. **Battery Drain**: < 5% per hour active use

**Tools:**
- Flutter DevTools for performance profiling
- Firebase Performance Monitoring
- Custom analytics events for timing

## Security Considerations

### Firebase Security Rules

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
             exists(/databases/$(database)/documents/adminUsers/$(request.auth.uid)) &&
             get(/databases/$(database)/documents/adminUsers/$(request.auth.uid)).data.isAdmin == true;
    }
    
    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow create: if isAuthenticated();
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    match /solutions/{solutionId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
    
    match /analytics/{userId} {
      allow read, write: if isOwner(userId) || isAdmin();
    }
    
    match /books/{bookId} {
      allow read, write: if isOwner(resource.data.userId);
    }
    
    match /studyPlans/{planId} {
      allow read, write: if isOwner(resource.data.userId);
    }
    
    match /topicNotes/{noteId} {
      allow read, write: if isOwner(resource.data.userId);
    }
    
    match /adminUsers/{adminId} {
      allow read: if isAdmin();
      allow write: if false; // Only manual updates
    }
  }
}
```

**Storage Rules:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isValidImageSize(maxSizeMB) {
      return request.resource.size < maxSizeMB * 1024 * 1024;
    }
    
    function isValidImageType() {
      return request.resource.contentType.matches('image/.*');
    }
    
    match /profile_photos/{userId}/{fileName} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId) && 
                      isValidImageSize(5) && 
                      isValidImageType();
    }
    
    match /question_images/{userId}/{fileName} {
      allow read: if isOwner(userId);
      allow write: if isOwner(userId) && 
                      isValidImageSize(20) && 
                      isValidImageType();
    }
    
    match /book_covers/{userId}/{fileName} {
      allow read, write: if isOwner(userId) && isValidImageSize(5);
    }
    
    match /note_images/{userId}/{fileName} {
      allow read, write: if isOwner(userId) && isValidImageSize(10);
    }
  }
}
```

### API Key Protection

**Cloud Functions Environment:**
```javascript
// Store API keys in Firebase Functions config
// Never expose in mobile app code

const functions = require('firebase-functions');
const openaiKey = functions.config().openai.key;
const geminiKey = functions.config().gemini.key;

// Set using Firebase CLI:
// firebase functions:config:set openai.key="sk-..."
// firebase functions:config:set gemini.key="..."
```

### Data Encryption

1. **In Transit**: All Firebase communication uses HTTPS/TLS
2. **At Rest**: Firebase automatically encrypts data at rest
3. **Sensitive Data**: User passwords hashed by Firebase Auth
4. **Local Storage**: SharedPreferences encrypted on device

### Rate Limiting

**Cloud Functions:**
```javascript
// Implement rate limiting to prevent abuse
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Max 100 requests per window per user
  keyGenerator: (req) => req.auth.uid,
});

exports.analyzeSolution = functions
  .runWith({ timeoutSeconds: 60, memory: '1GB' })
  .https.onCall(async (data, context) => {
    // Rate limiting logic
    // AI processing
  });
```

## Deployment Strategy

### Development Environment
- Firebase project: `limoncuk-dev`
- Test data and sandbox AI keys
- Debug builds with verbose logging

### Staging Environment
- Firebase project: `limoncuk-staging`
- Production-like data
- Beta testing with TestFlight/Internal Testing

### Production Environment
- Firebase project: `limoncuk-prod`
- Production AI keys with monitoring
- Release builds with minimal logging

### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze
  
  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_JSON }}
          packageName: com.limoncuk.egitim
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
  
  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release --no-codesign
      - uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/iphoneos/Runner.app
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}
```

### Monitoring and Analytics

**Firebase Analytics Events:**
- `question_solved`: Track question completion
- `solution_marked_correct`: Track successful solutions
- `solution_retry`: Track retry attempts
- `achievement_unlocked`: Track achievement progress
- `study_session_completed`: Track study plan adherence
- `screen_view`: Track navigation patterns

**Firebase Crashlytics:**
- Automatic crash reporting
- Custom error logging
- User identification for debugging

**Firebase Performance Monitoring:**
- Network request timing
- Screen rendering performance
- Custom traces for critical operations

## Scalability Considerations

### Database Optimization

1. **Indexing**: Create composite indexes for common queries
2. **Pagination**: Limit query results (20-50 items per page)
3. **Denormalization**: Store frequently accessed data redundantly
4. **Batch Operations**: Use batch writes for multiple updates

### Caching Strategy

1. **Image Caching**: Use cached_network_image with LRU cache
2. **Data Caching**: Cache Firestore queries with TTL
3. **Offline Persistence**: Enable Firestore offline persistence
4. **Memory Management**: Clear caches on memory warnings

### Cloud Functions Optimization

1. **Cold Start Reduction**: Keep functions warm with scheduled pings
2. **Memory Allocation**: Allocate appropriate memory (512MB-1GB)
3. **Timeout Configuration**: Set realistic timeouts (30-60s for AI)
4. **Concurrent Execution**: Allow multiple instances for high load

### Cost Optimization

1. **Firestore Reads**: Minimize unnecessary queries with caching
2. **Storage**: Compress images before upload
3. **Cloud Functions**: Optimize execution time to reduce costs
4. **AI API**: Monitor usage and implement fallback strategies

## Future Enhancements

### Phase 2 Features (Post-Launch)

1. **Voice Assistant**: Text-to-speech for solution playback
2. **Collaborative Study**: Share solutions with friends
3. **Live Tutoring**: Connect with tutors for help
4. **Gamification**: Leaderboards and competitions
5. **AR Features**: Augmented reality for 3D visualizations
6. **Video Solutions**: AI-generated video explanations
7. **Practice Tests**: Generate custom practice exams
8. **Parent Dashboard**: Track child's progress
9. **School Integration**: Connect with school systems
10. **Multi-language Support**: Expand beyond Turkish and English

### Technical Debt Management

1. **Code Refactoring**: Regular refactoring sprints
2. **Dependency Updates**: Monthly package updates
3. **Performance Audits**: Quarterly performance reviews
4. **Security Audits**: Annual security assessments
5. **Documentation**: Maintain up-to-date technical docs
