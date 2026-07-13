import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../data/auth_service.dart';

// Exposes a single instance of AuthService to the whole app
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Streams Firebase's raw auth state (logged in / logged out)
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Fetches the full Firestore profile (name, role, etc.) for the current user
final currentUserProfileProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateChangesProvider);
  final authService = ref.watch(authServiceProvider);

  return authState.when(
    data: (user) async {
      if (user == null) return null;
      return authService.getUserProfile(user.uid);
    },
    loading: () async => null,
    // ignore: unnecessary_underscores
    error: (_, __) async => null,
  );
});