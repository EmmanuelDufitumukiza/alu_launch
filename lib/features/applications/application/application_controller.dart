import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/application_model.dart';
import 'application_providers.dart';

class ApplicationController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  ApplicationController(this.ref) : super(const AsyncData(null));

  // Returns an error message string if it fails / already applied, null on success
  Future<String?> applyToOpportunity({
    required String opportunityId,
    required String opportunityTitle,
    required String studentUid,
    required String studentName,
    required String coverNote,
  }) async {
    final repo = ref.read(applicationRepositoryProvider);

    final alreadyApplied = await repo.hasAlreadyApplied(opportunityId, studentUid);
    if (alreadyApplied) {
      return 'You already applied to this opportunity.';
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final application = ApplicationModel(
        id: '',
        opportunityId: opportunityId,
        opportunityTitle: opportunityTitle,
        studentUid: studentUid,
        studentName: studentName,
        coverNote: coverNote,
        appliedAt: DateTime.now(),
      );
      await repo.apply(application);
    });

    return state.hasError ? 'Something went wrong. Please try again.' : null;
  }

  Future<void> setStatus(String applicationId, String status) async {
    final repo = ref.read(applicationRepositoryProvider);
    await repo.updateStatus(applicationId, status);
  }
}

final applicationControllerProvider =
    StateNotifierProvider<ApplicationController, AsyncValue<void>>((ref) {
  return ApplicationController(ref);
});