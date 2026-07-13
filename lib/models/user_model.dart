enum UserRole { student, startupAdmin }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final String? photoUrl;
  final List<String> skills; // relevant for students
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl,
    this.skills = const [],
    required this.createdAt,
  });

  // Convert Firestore document -> UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: (map['role'] == 'startupAdmin')
          ? UserRole.startupAdmin
          : UserRole.student,
      photoUrl: map['photoUrl'],
      skills: List<String>.from(map['skills'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert UserModel -> Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role == UserRole.startupAdmin ? 'startupAdmin' : 'student',
      'photoUrl': photoUrl,
      'skills': skills,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}