import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/application_model.dart';
import '../data/application_repository.dart';
import '../../auth/application/auth_providers.dart';

final applicationRepositoryProvider = Provider((ref) => ApplicationRepository());

final myApplicationsProvider = StreamProvider<List<ApplicationModel>>((ref) {
  final repo = ref.watch(applicationRepositoryProvider);
  final userAsync = ref.watch(currentUserProfileProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value(<ApplicationModel>[]);
      return repo.watchMyApplications(user.uid);
    },
    loading: () => Stream.value(<ApplicationModel>[]),
    // ignore: unnecessary_underscores
    error: (_, __) => Stream.value(<ApplicationModel>[]),
  );
});

final applicantsForOpportunityProvider =
    StreamProvider.family<List<ApplicationModel>, String>((ref, opportunityId) {
  return ref.watch(applicationRepositoryProvider).watchApplicantsForOpportunity(opportunityId);
});