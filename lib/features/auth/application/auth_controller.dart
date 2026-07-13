import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import 'auth_providers.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AuthController(this.ref) : super(const AsyncData(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    final authService = ref.read(authServiceProvider);

    state = await AsyncValue.guard(() async {
      await authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final authService = ref.read(authServiceProvider);

    state = await AsyncValue.guard(() async {
      await authService.signIn(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});