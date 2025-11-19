import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/models.dart';

/// Authentication state management provider
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // State variables
  User? _firebaseUser;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isInitialized => _isInitialized;
  bool get hasCompletedProfile =>
      _userProfile != null &&
      _userProfile!.studentClass.isNotEmpty &&
      _userProfile!.examTypes.isNotEmpty;

  /// Initialize auth state
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserProfile(user.uid);
        await _authRepository.updateLastActive(user.uid);
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });

    // Load current user if exists
    _firebaseUser = _authRepository.currentUser;
    if (_firebaseUser != null) {
      await _loadUserProfile(_firebaseUser!.uid);
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Load user profile from Firestore
  Future<void> _loadUserProfile(String uid) async {
    try {
      _userProfile = await _authRepository.getUserProfile(uid);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Profil yüklenemedi: $e';
      debugPrint('Error loading user profile: $e');
    }
  }

  /// Sign in with email and password
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final userCredential = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      _firebaseUser = userCredential.user;
      if (_firebaseUser != null) {
        await _loadUserProfile(_firebaseUser!.uid);
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _setLoading(true);
    try {
      final userCredential = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      _firebaseUser = userCredential.user;
      if (_firebaseUser != null) {
        await _loadUserProfile(_firebaseUser!.uid);
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final userCredential = await _authRepository.signInWithGoogle();
      _firebaseUser = userCredential.user;
      if (_firebaseUser != null) {
        await _loadUserProfile(_firebaseUser!.uid);
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Apple
  Future<bool> signInWithApple() async {
    _setLoading(true);
    try {
      final userCredential = await _authRepository.signInWithApple();
      _firebaseUser = userCredential.user;
      if (_firebaseUser != null) {
        await _loadUserProfile(_firebaseUser!.uid);
      }
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _authRepository.sendPasswordResetEmail(email);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile(UserProfile updatedProfile) async {
    _setLoading(true);
    try {
      await _authRepository.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Profil güncellenemedi: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Update user settings
  Future<bool> updateSettings(UserSettings settings) async {
    if (_userProfile == null) return false;

    final updatedProfile = _userProfile!.copyWith(settings: settings);
    return await updateProfile(updatedProfile);
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
      _firebaseUser = null;
      _userProfile = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Çıkış yapılamadı: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    if (_firebaseUser == null) return false;

    _setLoading(true);
    try {
      await _authRepository.deleteAccount(_firebaseUser!.uid);
      _firebaseUser = null;
      _userProfile = null;
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Hesap silinemedi: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Reload user
  Future<void> reloadUser() async {
    if (_firebaseUser == null) return;

    await _authRepository.reloadUser();
    await _loadUserProfile(_firebaseUser!.uid);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
