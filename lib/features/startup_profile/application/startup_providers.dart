import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../data/startup_repository.dart';
import '../../auth/application/auth_providers.dart';

final startupRepositoryProvider = Provider((ref) => StartupRepository());

final myStartupProvider = StreamProvider<StartupModel?>((ref) {
  final repo = ref.watch(startupRepositoryProvider);
  final userAsync = ref.watch(currentUserProfileProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return repo.watchMyStartup(user.uid);
    },
    loading: () => Stream.value(null),
    // ignore: unnecessary_underscores
    error: (_, __) => Stream.value(null),
  );
});