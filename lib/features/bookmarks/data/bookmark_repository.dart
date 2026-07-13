import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkRepository {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference _userBookmarks(String uid) =>
      _firestore.collection('users').doc(uid).collection('bookmarks');

  Future<void> toggleBookmark(String uid, String opportunityId) async {
    final doc = _userBookmarks(uid).doc(opportunityId);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      await doc.delete();
    } else {
      await doc.set({'opportunityId': opportunityId, 'savedAt': DateTime.now().toIso8601String()});
    }
  }

  Stream<Set<String>> watchBookmarkedIds(String uid) {
    return _userBookmarks(uid).snapshots().map(
        (snap) => snap.docs.map((d) => d.id).toSet());
  }
}