import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/opportunity_model.dart';
import 'opportunity_providers.dart';

class OpportunityController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  OpportunityController(this.ref) : super(const AsyncData(null));

  Future<void> postOpportunity({
    required String startupId,
    required String startupName,
    required String title,
    required String description,
    required String roleType,
    required String commitment,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(opportunityRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final opp = OpportunityModel(
        id: '',
        startupId: startupId,
        startupName: startupName,
        title: title,
        description: description,
        roleType: roleType,
        commitment: commitment,
        createdAt: DateTime.now(),
      );
      await repo.createOpportunity(opp);
    });
  }

  Future<void> closeOpportunity(String id) async {
    final repo = ref.read(opportunityRepositoryProvider);
    await repo.updateStatus(id, 'closed');
  }

  Future<void> deleteOpportunity(String id) async {
    final repo = ref.read(opportunityRepositoryProvider);
    await repo.deleteOpportunity(id);
  }
}

final opportunityControllerProvider =
    StateNotifierProvider<OpportunityController, AsyncValue<void>>((ref) {
  return OpportunityController(ref);
});