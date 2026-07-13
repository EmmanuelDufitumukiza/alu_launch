import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/application_model.dart';

class ApplicationRepository {
  final _col = FirebaseFirestore.instance.collection('applications');

  Future<void> apply(ApplicationModel application) async {
    await _col.add(application.toMap());
  }

  Future<void> updateStatus(String id, String status) async {
    await _col.doc(id).update({'status': status});
  }

  // A student's own applications — real-time, so status changes appear instantly
  Stream<List<ApplicationModel>> watchMyApplications(String studentUid) {
    return _col
        .where('studentUid', isEqualTo: studentUid)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ApplicationModel.fromMap(d.data(), d.id))
            .toList());
  }

  // All applicants for one opportunity (startup admin's review screen)
  Stream<List<ApplicationModel>> watchApplicantsForOpportunity(String opportunityId) {
    return _col
        .where('opportunityId', isEqualTo: opportunityId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ApplicationModel.fromMap(d.data(), d.id))
            .toList());
  }

  Future<bool> hasAlreadyApplied(String opportunityId, String studentUid) async {
    final snap = await _col
        .where('opportunityId', isEqualTo: opportunityId)
        .where('studentUid', isEqualTo: studentUid)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }
}