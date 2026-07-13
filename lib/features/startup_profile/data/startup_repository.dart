import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/startup_model.dart';

class StartupRepository {
  final _col = FirebaseFirestore.instance.collection('startups');

  Future<void> createStartup(StartupModel startup) async {
    await _col.doc(startup.id).set(startup.toMap());
  }

  // Real-time stream of the startup owned by this founder (null if none yet)
  Stream<StartupModel?> watchMyStartup(String founderUid) {
    return _col
        .where('founderUid', isEqualTo: founderUid)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return StartupModel.fromMap(doc.data(), doc.id);
    });
  }

  Stream<StartupModel?> watchStartupById(String id) {
    return _col.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return StartupModel.fromMap(doc.data()!, doc.id);
    });
  }
}