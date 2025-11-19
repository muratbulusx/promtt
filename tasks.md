# Implementation Plan

- [ ] 1. Set up project foundation and Firebase infrastructure
  - Create Flutter project with proper package name and bundle identifiers
  - Configure Firebase for iOS and Android (Auth, Firestore, Storage, Functions, Messaging)
  - Set up development, staging, and production Firebase projects
  - Implement core folder structure following clean architecture pattern
  - Create base theme system with light and dark mode color palettes
  - _Requirements: 1.1, 1.2, 1.3, 10.1, 10.2_

- [ ] 2. Implement authentication system
  - [ ] 2.1 Create authentication data models and repositories
    - Write UserProfile model with JSON serialization
    - Write UserSettings model with all configuration options
    - Implement AuthRepository with Firebase Authentication wrapper
    - Create AuthProvider for state management
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 1.6_
  
  - [ ] 2.2 Build authentication UI screens
    - Create LoginScreen with email/password fields and validation
    - Create RegisterScreen with profile setup (name, class, exam types)
    - Create ForgotPasswordScreen with email input
    - Implement Google Sign-In button and flow
    - Implement Apple Sign-In button and flow (iOS only)
    - Add loading states and error handling to all auth screens
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [ ] 2.3 Implement profile management features
    - Create ProfileScreen with editable fields
    - Implement profile photo upload with image picker
    - Add image compression before upload (max 5MB)
    - Create settings screen with user preferences
    - Implement logout functionality
    - _Requirements: 1.5, 1.6_
  
  - [ ] 2.4 Write authentication tests
    - Unit tests for AuthRepository methods
    - Widget tests for login/register screens
    - Integration test for complete auth flow
    - _Requirements: 1.1, 1.2, 1.3_

- [ ] 3. Build question solving core functionality
  - [ ] 3.1 Create solution data models and services
    - Write Solution model with all fields and JSON serialization
    - Write SolutionStep model for step-by-step solutions
    - Implement SolutionRepository for Firestore operations
    - Create SolutionProvider for state management
    - _Requirements: 2.1, 2.4, 2.5, 2.6, 2.7_
  
  - [ ] 3.2 Implement camera and image processing
    - Create CameraScreen with full-screen preview
    - Add camera controls (flash, front/back switch)
    - Implement image picker for gallery selection
    - Create ImageEditingScreen with crop, rotate, brightness, contrast tools
    - Add image compression and optimization before upload
    - Validate image size (max 20MB) and format (JPG, PNG, WebP)
    - _Requirements: 2.1, 2.2_
  
  - [ ] 3.3 Build exam and subject selection UI
    - Create ExamSelectionScreen with grid of exam types
    - Create SubjectSelectionScreen with subject options
    - Add optional topic selection dropdown
    - Implement navigation flow: Camera → Exam → Subject → Processing
    - _Requirements: 2.3_
  
  - [ ] 3.4 Implement Firebase Storage upload
    - Create StorageService for file uploads
    - Upload question images to Firebase Storage with user-specific paths
    - Generate and return signed URLs for uploaded images
    - Add upload progress indicator
    - Handle upload errors with retry logic
    - _Requirements: 2.4, 10.4_
  
  - [ ] 3.5 Create Cloud Function for AI integration
    - Write Cloud Function `analyzeSolutionWithAI` in Node.js
    - Implement GPT-4 API integration with vision capabilities
    - Implement Gemini API integration as alternative
    - Parse AI responses into structured Solution format
    - Handle AI errors with retry logic and exponential backoff
    - Store API keys securely in Functions config
    - _Requirements: 2.5, 2.6, 10.6_
  
  - [ ] 3.6 Build solution display screen
    - Create SolutionScreen with scrollable content
    - Display question image thumbnail (tappable for full view)
    - Show subject, topic, and difficulty badges
    - Render step-by-step solution with expandable cards
    - Implement LaTeX formula rendering using flutter_math_fork
    - Display correct answer prominently
    - Show option analysis in expandable section
    - Display topic explanation and exam tips
    - Add action buttons: Mark Correct, Mark Incorrect/Retry, Save, Share
    - _Requirements: 2.7_
  
  - [ ] 3.7 Implement solution retry mechanism
    - Handle "Mark Incorrect" button tap
    - Increment retry count in Firestore
    - Resubmit question to Cloud Function with retry context
    - Display new solution with retry indicator
    - _Requirements: 2.8_
  
  - [ ] 3.8 Add solution marking and favorites
    - Implement "Mark Correct" to update isSuccessful field
    - Implement "Save to Favorites" to toggle isFavorite flag
    - Update Analytics when solution is marked
    - Show visual feedback for marked solutions
    - _Requirements: 2.9, 2.10_
  
  - [ ] 3.9 Write question solving tests
    - Unit tests for SolutionRepository
    - Widget tests for camera and solution screens
    - Integration test for complete solving flow
    - Mock Cloud Function responses for testing
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7_

- [ ] 4. Implement analytics and statistics system
  - [ ] 4.1 Create analytics data models
    - Write StudentAnalytics model with all statistics fields
    - Write SubjectStats model for subject-level data
    - Write TopicPerformance model with trend calculation
    - Write DailyStats model for daily activity tracking
    - Write Achievement model for badge system
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10_
  
  - [ ] 4.2 Implement analytics calculation service
    - Create AnalyticsService with calculation methods
    - Implement success rate calculation
    - Implement streak tracking logic (increment/reset)
    - Implement weak topics identification (< 60% success)
    - Implement strong topics identification (> 80% success)
    - Implement trend analysis using linear regression
    - Create AnalyticsRepository for Firestore operations
    - _Requirements: 3.4, 3.5, 3.6, 3.9, 3.10_
  
  - [ ] 4.3 Build analytics update Cloud Function
    - Write Cloud Function to update analytics after each question
    - Update total questions, success/fail counts
    - Update subject and topic statistics
    - Update daily activity map
    - Check and unlock achievements
    - Use Firestore transactions for consistency
    - _Requirements: 3.1, 3.2, 3.3_
  
  - [ ] 4.4 Create statistics dashboard UI
    - Build StatsScreen with tabbed interface (General, Subjects, Topics, Achievements)
    - Display overview cards: Total Questions, Success Rate, Current Streak
    - Implement line chart for last 7 days activity using fl_chart
    - Implement pie chart for subject distribution
    - Display strong and weak topics lists
    - _Requirements: 3.4, 3.5, 3.8_
  
  - [ ] 4.5 Build subject and topic detail screens
    - Create SubjectDetailScreen showing subject-specific stats
    - Display topic performance list with success rates
    - Show trend indicators (📈 improving, 📉 declining, ➡️ stable)
    - Add filtering and sorting options
    - Create TopicDetailScreen with attempt history
    - _Requirements: 3.5, 3.6_
  
  - [ ] 4.6 Implement activity calendar widget
    - Create calendar view showing current month
    - Color-code days based on question count (gray, yellow, green, blue)
    - Display legend explaining color meanings
    - Make days tappable to show daily details
    - _Requirements: 3.8_
  
  - [ ] 4.7 Build achievement system
    - Define achievement milestones in constants
    - Implement achievement checking logic in AnalyticsService
    - Create AchievementsScreen displaying locked and unlocked badges
    - Show progress bars for in-progress achievements
    - Display achievement unlock animations
    - _Requirements: 3.7_
  
  - [ ] 4.8 Write analytics tests
    - Unit tests for all calculation methods
    - Test streak increment and reset logic
    - Test weak/strong topic identification
    - Test trend calculation accuracy
    - Widget tests for stats screens
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_

- [ ] 5. Develop intelligent study planning system
  - [ ] 5.1 Create study plan data models
    - Write WeeklyStudyPlan model with JSON serialization
    - Write DailyPlan model for daily schedule
    - Write StudySession model with all session details
    - Write StudyPreferences model for user preferences
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9_
  
  - [ ] 5.2 Implement plan generation algorithm
    - Create StudyPlanService with generation logic
    - Fetch user analytics for last 14 days
    - Identify weak topics (success rate < 60%)
    - Identify neglected topics (not studied in 7+ days)
    - Calculate priority scores for topics
    - Distribute sessions across weekdays based on daily study duration
    - Balance subjects (max 2 sessions per subject per day)
    - Include review sessions on weekends
    - _Requirements: 4.2, 4.3, 4.4, 4.8, 4.9_
  
  - [ ] 5.3 Create Cloud Function for AI recommendations
    - Write Cloud Function `generateWeeklyPlan`
    - Call GPT-4/Gemini to generate motivational AI recommendation
    - Include context about weak topics and study goals
    - Return complete study plan with AI recommendation
    - _Requirements: 4.5_
  
  - [ ] 5.4 Build study plan UI screens
    - Create StudyPlanScreen with weekly overview
    - Display AI recommendation in expandable card
    - Show weekly progress bar (questions solved / target)
    - Display daily plans with completed/pending indicators
    - Show session details: subject, topic, duration, target questions
    - Add "New Plan" button to generate fresh plan
    - Add "Customize" button for manual editing
    - _Requirements: 4.6, 4.7_
  
  - [ ] 5.5 Implement session completion tracking
    - Add "Complete Session" button to each session
    - Update session completion status in Firestore
    - Track actual questions solved vs target
    - Update daily plan completion status
    - Show completion checkmarks and progress
    - _Requirements: 4.6_
  
  - [ ] 5.6 Write study plan tests
    - Unit tests for plan generation algorithm
    - Test weak topic identification
    - Test session distribution logic
    - Test priority score calculation
    - Widget tests for study plan screens
    - _Requirements: 4.1, 4.2, 4.3, 4.4_


- [ ] 6. Build library and content management features
  - [ ] 6.1 Create book and note data models
    - Write Book model with chapters and progress tracking
    - Write Chapter model with page ranges and topics
    - Write TopicNote model with markdown support
    - Implement JSON serialization for all models
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8_
  
  - [ ] 6.2 Implement book management service
    - Create BookService with CRUD operations
    - Implement BookRepository for Firestore operations
    - Add book progress calculation logic
    - Add chapter completion tracking
    - Create BookProvider for state management
    - _Requirements: 5.1, 5.2, 5.3, 5.4_
  
  - [ ] 6.3 Build book management UI
    - Create LibraryScreen with tabs: Books, Solutions, Notes, Favorites
    - Create BooksScreen with book list and search
    - Implement "Add Book" dialog with manual entry
    - Display book cards with cover, title, author, progress bar
    - Create BookDetailScreen showing chapters and progress
    - Add chapter completion checkboxes
    - Implement page number update input
    - _Requirements: 5.1, 5.3, 5.4_
  
  - [ ] 6.4 Implement barcode scanning for books
    - Integrate mobile_scanner package
    - Create BarcodeScannerScreen with camera preview
    - Parse ISBN from barcode
    - Attempt to fetch book info from external API (optional)
    - Create book from scanned ISBN
    - _Requirements: 5.2_
  
  - [ ] 6.5 Implement topic notes system
    - Create NoteService with CRUD operations
    - Implement NoteRepository for Firestore operations
    - Create NoteProvider for state management
    - Build NotesScreen with list of notes
    - Implement search and filter functionality
    - Add tag-based filtering
    - _Requirements: 5.5, 5.7_
  
  - [ ] 6.6 Build note editor with markdown support
    - Create NoteEditorScreen with markdown text field
    - Implement markdown preview toggle
    - Add LaTeX formula support in notes
    - Implement image attachment from gallery/camera
    - Upload note images to Firebase Storage
    - Add pin/unpin functionality
    - Add tag management
    - _Requirements: 5.5, 5.8_
  
  - [ ] 6.7 Implement auto-generated notes from solutions
    - Check user settings for autoAddNotes flag
    - Create TopicNote automatically after solution is generated
    - Use AI-generated topic explanation as note content
    - Link note to solution with linkedSolutionId
    - _Requirements: 5.6_
  
  - [ ] 6.8 Build solutions history screen
    - Create SolutionsScreen showing all past solutions
    - Display solution cards with subject, topic, date
    - Add filter by subject, exam type, date range
    - Add search by topic or content
    - Make cards tappable to view full solution
    - Show favorite indicator on saved solutions
    - _Requirements: 2.10_
  
  - [ ] 6.9 Write library module tests
    - Unit tests for BookService and NoteService
    - Test progress calculation logic
    - Test search and filter functionality
    - Widget tests for book and note screens
    - _Requirements: 5.1, 5.2, 5.3, 5.5_

- [ ] 7. Implement admin panel and management features
  - [ ] 7.1 Create admin data models and services
    - Write AdminUser model with permissions
    - Write AdminDashboard model for statistics
    - Write UserDetailData model for user info
    - Create AdminService with admin operations
    - Implement AdminRepository with elevated Firestore access
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7_
  
  - [ ] 7.2 Implement admin authentication check
    - Create isAdmin() method checking adminUsers collection
    - Add admin route guard to prevent unauthorized access
    - Show/hide admin menu item based on admin status
    - _Requirements: 7.1_
  
  - [ ] 7.3 Build admin dashboard screen
    - Create AdminDashboardScreen with statistics overview
    - Display total users, active users, total questions cards
    - Implement line chart for user growth (last 30 days)
    - Implement bar chart for popular subjects
    - Show today's activity summary
    - _Requirements: 7.2_
  
  - [ ] 7.4 Build user management screens
    - Create UsersScreen with searchable user list
    - Implement user search by name, email, or ID
    - Add filters for class, status, activity
    - Display user cards with key statistics
    - Create UserDetailScreen showing complete user profile
    - Show user's analytics, books, study plans, recent solutions
    - _Requirements: 7.3, 7.4_
  
  - [ ] 7.5 Implement user ban/unban functionality
    - Add "Ban User" button in UserDetailScreen
    - Create ban confirmation dialog with reason input
    - Update user document with banned flag
    - Add "Unban User" button for banned users
    - Prevent banned users from using the app
    - _Requirements: 7.6_
  
  - [ ] 7.6 Build reports and analytics screen
    - Create ReportsScreen with date range selector
    - Calculate and display user growth metrics
    - Show question solving trends with charts
    - Display subject distribution pie chart
    - List difficult topics (low success rate)
    - List most retried topics
    - Add export to PDF/Excel functionality
    - _Requirements: 7.5, 7.7_
  
  - [ ] 7.7 Write admin module tests
    - Unit tests for admin service methods
    - Test admin authentication check
    - Test report generation logic
    - Widget tests for admin screens
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

- [ ] 8. Implement notification system
  - [ ] 8.1 Set up Firebase Cloud Messaging
    - Configure FCM for iOS and Android
    - Request notification permissions on app launch
    - Get and store FCM token in user document
    - Handle token refresh
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_
  
  - [ ] 8.2 Create notification service
    - Write NotificationService with FCM integration
    - Implement flutter_local_notifications for local scheduling
    - Create notification handler for deep linking
    - Handle notification taps and navigate to appropriate screens
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_
  
  - [ ] 8.3 Implement local notification scheduling
    - Schedule daily reminder at user-specified time
    - Schedule streak warning at 23:00 if no questions solved
    - Schedule study session reminders based on weekly plan
    - Cancel notifications when user completes actions
    - _Requirements: 8.1, 8.5, 8.6_
  
  - [ ] 8.4 Create Cloud Functions for push notifications
    - Write Cloud Function to send solution ready notification
    - Write Cloud Function to send achievement unlocked notification
    - Write scheduled Cloud Function for weekly summary (Sunday 21:00)
    - Include deep link data in notification payload
    - _Requirements: 8.2, 8.3, 8.4_
  
  - [ ] 8.5 Build notification settings UI
    - Add notification preferences to SettingsScreen
    - Add toggles for each notification type
    - Add time picker for daily reminder
    - Save preferences to user settings in Firestore
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_
  
  - [ ] 8.6 Write notification tests
    - Unit tests for notification scheduling logic
    - Test deep linking navigation
    - Test notification permission handling
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_

- [ ] 9. Implement offline mode and data synchronization
  - [ ] 9.1 Enable Firestore offline persistence
    - Configure Firestore with offline persistence enabled
    - Set cache size limit appropriately
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_
  
  - [ ] 9.2 Implement local caching for solutions
    - Cache loaded solutions using Hive or SharedPreferences
    - Display cached solutions when offline
    - Show offline indicator in UI
    - _Requirements: 9.1_
  
  - [ ] 9.3 Implement offline note editing
    - Allow creating and editing notes offline
    - Store changes locally with pending sync flag
    - Queue changes for upload when online
    - _Requirements: 9.2_
  
  - [ ] 9.4 Implement offline book progress updates
    - Allow updating book progress offline
    - Store changes locally with pending sync flag
    - Queue changes for upload when online
    - _Requirements: 9.3_
  
  - [ ] 9.5 Create synchronization service
    - Detect network connectivity changes
    - Sync pending changes when connection restored
    - Handle sync conflicts using timestamp comparison
    - Show sync progress indicator
    - Display sync errors with retry option
    - _Requirements: 9.4, 9.5_
  
  - [ ] 9.6 Write offline mode tests
    - Test offline data access
    - Test sync queue functionality
    - Test conflict resolution
    - Integration test for offline-to-online flow
    - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

- [ ] 10. Build main navigation and home screen
  - [ ] 10.1 Create bottom navigation structure
    - Implement bottom navigation bar with 5 tabs
    - Add icons and labels: Home, Solve, Stats, Library, Settings
    - Handle tab switching with state preservation
    - _Requirements: 6.1_
  
  - [ ] 10.2 Build home screen dashboard
    - Create HomeScreen with welcome message
    - Display daily goal progress card
    - Show current streak with fire emoji
    - Add prominent "Solve Question" button
    - Display this week's statistics summary
    - Show mini line chart for last 7 days
    - Display recommended topics based on weak areas
    - Show recent solutions list (last 3-5)
    - _Requirements: 6.1_
  
  - [ ] 10.3 Implement settings screen
    - Create SettingsScreen with categorized sections
    - Add profile section with photo and basic info
    - Add appearance section: dark mode toggle, language selector
    - Add AI settings: model selector, detail level
    - Add notification settings (from task 8.5)
    - Add study preferences: daily goal, preferred hours
    - Add account section: change password, delete account, logout
    - Add about section: version, privacy policy, terms, contact
    - _Requirements: 6.2, 6.3_
  
  - [ ] 10.4 Implement theme switching
    - Create ThemeProvider for theme state management
    - Implement light and dark theme data
    - Apply theme changes immediately across app
    - Persist theme preference in SharedPreferences
    - _Requirements: 6.2_
  
  - [ ] 10.5 Implement language switching
    - Set up Flutter localization (l10n)
    - Create translation files for Turkish and English
    - Translate all UI strings
    - Apply language changes immediately
    - Persist language preference
    - _Requirements: 6.3_
  
  - [ ] 10.6 Write navigation and UI tests
    - Widget tests for bottom navigation
    - Test tab switching behavior
    - Test theme switching
    - Test language switching
    - Integration test for complete navigation flow
    - _Requirements: 6.1, 6.2, 6.3_

- [ ] 11. Implement onboarding and splash screen
  - [ ] 11.1 Create splash screen
    - Design splash screen with app logo and branding
    - Add animated logo or loading indicator
    - Check authentication state during splash
    - Navigate to onboarding or home based on auth state
    - _Requirements: 1.1_
  
  - [ ] 11.2 Build onboarding flow
    - Create OnboardingScreen with page view
    - Design 3-4 onboarding pages explaining key features
    - Add skip button and next/previous navigation
    - Add "Get Started" button on last page
    - Store onboarding completion flag
    - Navigate to registration after onboarding
    - _Requirements: 1.1_

- [ ] 12. Implement image optimization and caching
  - [ ] 12.1 Add image compression
    - Compress images before upload using image package
    - Resize large images to reasonable dimensions
    - Convert to WebP format for better compression
    - Maintain acceptable quality (80-90%)
    - _Requirements: 2.1, 2.2_
  
  - [ ] 12.2 Implement image caching
    - Use cached_network_image for all network images
    - Configure LRU cache with size limits
    - Add placeholder and error widgets
    - Implement progressive loading
    - _Requirements: 6.4_

- [ ] 13. Add error handling and logging
  - [ ] 13.1 Implement global error handler
    - Set up Flutter error handler
    - Configure Firebase Crashlytics
    - Log errors with context and stack traces
    - Display user-friendly error messages
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_
  
  - [ ] 13.2 Create error logging service
    - Write ErrorLogger with Crashlytics integration
    - Log critical errors to Firestore for admin review
    - Add custom error types and categories
    - Include user ID and device info in logs
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_
  
  - [ ] 13.3 Implement retry mechanisms
    - Add exponential backoff for AI requests
    - Add retry buttons for failed operations
    - Queue failed uploads for retry
    - Show retry progress to user
    - _Requirements: 2.5, 10.3_

- [ ] 14. Implement security measures
  - [ ] 14.1 Configure Firebase Security Rules
    - Write Firestore security rules for all collections
    - Write Storage security rules for all paths
    - Test rules with Firebase Emulator
    - Deploy rules to production
    - _Requirements: 10.3, 10.4, 10.6_
  
  - [ ] 14.2 Implement rate limiting
    - Add rate limiting to Cloud Functions
    - Limit requests per user per time window
    - Return appropriate error messages
    - Log rate limit violations
    - _Requirements: 10.7_
  
  - [ ] 14.3 Add data encryption
    - Encrypt sensitive data in SharedPreferences
    - Use HTTPS for all network requests
    - Validate SSL certificates
    - _Requirements: 10.1, 10.2_

- [ ] 15. Performance optimization
  - [ ] 15.1 Optimize Firestore queries
    - Add pagination to all list queries
    - Create composite indexes for complex queries
    - Limit query results (20-50 items)
    - Use Firestore listeners efficiently
    - _Requirements: 3.4, 3.5, 7.3_
  
  - [ ] 15.2 Optimize widget rendering
    - Use const constructors where possible
    - Add RepaintBoundary for complex widgets
    - Implement AutomaticKeepAliveClientMixin for tabs
    - Use ListView.builder for long lists
    - _Requirements: 6.1, 6.4, 6.5_
  
  - [ ] 15.3 Optimize app size and loading
    - Enable code shrinking and obfuscation
    - Compress assets and images
    - Use deferred loading for large features
    - Optimize dependencies
    - _Requirements: 6.4_

- [ ] 16. Add analytics and monitoring
  - [ ] 16.1 Implement Firebase Analytics events
    - Track question_solved events
    - Track solution_marked_correct/incorrect events
    - Track achievement_unlocked events
    - Track study_session_completed events
    - Track screen_view events for all screens
    - _Requirements: 3.1, 3.7, 4.6_
  
  - [ ] 16.2 Set up Firebase Performance Monitoring
    - Add custom traces for critical operations
    - Monitor network request performance
    - Track screen rendering performance
    - Set up alerts for performance degradation
    - _Requirements: 2.4, 2.5_

- [ ] 17. Prepare for deployment
  - [ ] 17.1 Create app icons and splash screens
    - Design app icon for iOS and Android
    - Generate all required icon sizes
    - Create adaptive icon for Android
    - Design splash screens for both platforms
    - _Requirements: 6.1_
  
  - [ ] 17.2 Configure app metadata
    - Set app name, version, and build number
    - Write app description for stores
    - Create privacy policy document
    - Create terms of service document
    - Prepare app screenshots for stores
    - _Requirements: 10.5_
  
  - [ ] 17.3 Set up CI/CD pipeline
    - Create GitHub Actions workflow for testing
    - Add automated build for Android (APK/AAB)
    - Add automated build for iOS (IPA)
    - Configure automated deployment to TestFlight
    - Configure automated deployment to Google Play Internal Testing
    - _Requirements: 10.1, 10.2_
  
  - [ ] 17.4 Perform final testing
    - Run all unit tests and ensure passing
    - Run all widget tests and ensure passing
    - Run integration tests on real devices
    - Perform manual testing of all features
    - Test on multiple device sizes and OS versions
    - Fix any critical bugs found
    - _Requirements: All_
  
  - [ ] 17.5 Deploy to production
    - Deploy Cloud Functions to production Firebase project
    - Deploy Firestore Security Rules
    - Deploy Storage Security Rules
    - Submit iOS app to App Store for review
    - Submit Android app to Google Play for review
    - Monitor crash reports and user feedback
    - _Requirements: All_
