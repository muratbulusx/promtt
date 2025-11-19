import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_settings.dart';

/// User profile data model
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final String studentClass;
  final List<String> examTypes;
  final List<String> subjects;
  final DateTime createdAt;
  final DateTime lastActive;
  final UserSettings settings;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.studentClass,
    required this.examTypes,
    required this.subjects,
    required this.createdAt,
    required this.lastActive,
    required this.settings,
  });

  /// Create UserProfile from Firestore document
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      studentClass: json['studentClass'] as String,
      examTypes: List<String>.from(json['examTypes'] as List),
      subjects: List<String>.from(json['subjects'] as List),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastActive: (json['lastActive'] as Timestamp).toDate(),
      settings: UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  /// Convert UserProfile to Firestore document
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'studentClass': studentClass,
      'examTypes': examTypes,
      'subjects': subjects,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'settings': settings.toJson(),
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? studentClass,
    List<String>? examTypes,
    List<String>? subjects,
    DateTime? createdAt,
    DateTime? lastActive,
    UserSettings? settings,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      studentClass: studentClass ?? this.studentClass,
      examTypes: examTypes ?? this.examTypes,
      subjects: subjects ?? this.subjects,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      settings: settings ?? this.settings,
    );
  }

  /// Create empty/default UserProfile
  factory UserProfile.empty(String uid, String email) {
    return UserProfile(
      uid: uid,
      email: email,
      displayName: '',
      photoURL: null,
      studentClass: '',
      examTypes: [],
      subjects: [],
      createdAt: DateTime.now(),
      lastActive: DateTime.now(),
      settings: UserSettings.defaults(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email;

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, studentClass: $studentClass)';
  }
}
