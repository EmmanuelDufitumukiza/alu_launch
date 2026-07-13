import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/opportunity_model.dart';
import '../../features/bookmarks/application/bookmark_providers.dart';
import '../../features/auth/application/auth_providers.dart';

class OpportunityCard extends ConsumerWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;
  final bool showBookmark;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
    this.showBookmark = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedIdsProvider).valueOrNull ?? {};
    final isBookmarked = bookmarkedIds.contains(opportunity.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(opportunity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(opportunity.startupName),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: [
                Chip(label: Text(opportunity.roleType), visualDensity: VisualDensity.compact),
                Chip(label: Text(opportunity.commitment), visualDensity: VisualDensity.compact),
              ],
            ),
          ],
        ),
        trailing: showBookmark
            ? IconButton(
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  final user = ref.read(currentUserProfileProvider).valueOrNull;
                  if (user != null) {
                    ref.read(bookmarkRepositoryProvider).toggleBookmark(user.uid, opportunity.id);
                  }
                },
              )
            : null,
      ),
    );
  }
}