import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import 'startup_providers.dart';

class StartupController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  StartupController(this.ref) : super(const AsyncData(null));

  Future<void> createStartup({
    required String name,
    required String description,
    required String category,
    required String founderUid,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(startupRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final docRef = FirebaseFirestore.instance.collection('startups').doc();
      final startup = StartupModel(
        id: docRef.id,
        name: name,
        description: description,
        category: category,
        founderUid: founderUid,
        verified: false,
        createdAt: DateTime.now(),
      );
      await repo.createStartup(startup);
    });
  }
}

final startupControllerProvider =
    StateNotifierProvider<StartupController, AsyncValue<void>>((ref) {
  return StartupController(ref);
});