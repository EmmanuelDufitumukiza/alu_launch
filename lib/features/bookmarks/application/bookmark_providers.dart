import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookmark_repository.dart';
import '../../auth/application/auth_providers.dart';

final bookmarkRepositoryProvider = Provider((ref) => BookmarkRepository());

final bookmarkedIdsProvider = StreamProvider<Set<String>>((ref) {
  final repo = ref.watch(bookmarkRepositoryProvider);
  final userAsync = ref.watch(currentUserProfileProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value(<String>{});
      return repo.watchBookmarkedIds(user.uid);
    },
    loading: () => Stream.value(<String>{}),
    // ignore: unnecessary_underscores
    error: (_, __) => Stream.value(<String>{}),
  );
});