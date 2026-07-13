import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/opportunity_model.dart';

class OpportunityRepository {
  final _col = FirebaseFirestore.instance.collection('opportunities');

  Future<void> createOpportunity(OpportunityModel opp) async {
    await _col.add(opp.toMap());
  }

  Future<void> updateStatus(String id, String status) async {
    await _col.doc(id).update({'status': status});
  }

  Future<void> deleteOpportunity(String id) async {
    await _col.doc(id).delete();
  }

  // All open opportunities, newest first — real-time
  Stream<List<OpportunityModel>> watchAllOpen() {
    return _col
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OpportunityModel.fromMap(d.data(), d.id))
            .toList());
  }

  // Opportunities posted by one startup (for the admin's own management screen)
  Stream<List<OpportunityModel>> watchByStartup(String startupId) {
    return _col
        .where('startupId', isEqualTo: startupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => OpportunityModel.fromMap(d.data(), d.id))
            .toList());
  }
}