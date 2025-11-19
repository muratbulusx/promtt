import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase initialization and configuration service
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  // Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  bool _initialized = false;

  /// Initialize Firebase and all related services
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        // Note: firebase_options.dart should be generated using:
        // flutterfire configure
        // options: DefaultFirebaseOptions.currentPlatform,
      );

      // Enable Firestore offline persistence
      await _enableFirestoreOfflinePersistence();

      // Initialize Crashlytics
      await _initializeCrashlytics();

      // Initialize Analytics
      await _initializeAnalytics();

      _initialized = true;
      debugPrint('✅ Firebase initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Firebase initialization error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Enable Firestore offline persistence
  Future<void> _enableFirestoreOfflinePersistence() async {
    try {
      if (!kIsWeb) {
        // Enable offline persistence for mobile platforms
        await firestore.enablePersistence(
          const PersistenceSettings(synchronizeTabs: true),
        );
        debugPrint('✅ Firestore offline persistence enabled');
      }
    } catch (e) {
      debugPrint('⚠️ Firestore persistence error (may already be enabled): $e');
    }
  }

  /// Initialize Firebase Crashlytics
  Future<void> _initializeCrashlytics() async {
    try {
      // Pass all uncaught errors to Crashlytics
      FlutterError.onError = crashlytics.recordFlutterError;

      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      debugPrint('✅ Crashlytics initialized');
    } catch (e) {
      debugPrint('⚠️ Crashlytics initialization error: $e');
    }
  }

  /// Initialize Firebase Analytics
  Future<void> _initializeAnalytics() async {
    try {
      await analytics.setAnalyticsCollectionEnabled(true);
      debugPrint('✅ Analytics initialized');
    } catch (e) {
      debugPrint('⚠️ Analytics initialization error: $e');
    }
  }

  /// Log analytics event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Analytics event error: $e');
    }
  }

  /// Set user properties for analytics
  Future<void> setUserProperties({
    required String userId,
    required String studentClass,
    required List<String> examTypes,
  }) async {
    try {
      await analytics.setUserId(id: userId);
      await analytics.setUserProperty(
        name: 'student_class',
        value: studentClass,
      );
      await analytics.setUserProperty(
        name: 'exam_types',
        value: examTypes.join(','),
      );
    } catch (e) {
      debugPrint('Set user properties error: $e');
    }
  }

  /// Set current screen for analytics
  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClassOverride,
  }) async {
    try {
      await analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClassOverride ?? screenName,
      );
    } catch (e) {
      debugPrint('Set current screen error: $e');
    }
  }

  /// Sign out and clear user data
  Future<void> signOut() async {
    try {
      await auth.signOut();
      await analytics.resetAnalyticsData();
      debugPrint('✅ User signed out successfully');
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => auth.currentUser != null;

  /// Get current user ID
  String? get currentUserId => auth.currentUser?.uid;

  /// Get current user
  User? get currentUser => auth.currentUser;

  /// Listen to auth state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Check Firebase initialization status
  bool get isInitialized => _initialized;
}
