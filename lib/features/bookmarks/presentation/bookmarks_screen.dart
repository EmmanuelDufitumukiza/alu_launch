import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/bookmark_providers.dart';
import '../../opportunities/application/opportunity_providers.dart';
import '../../../core/widgets/opportunity_card.dart';
import '../../opportunities/presentation/opportunity_detail_screen.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedIdsProvider).valueOrNull ?? {};
    final allOpportunities = ref.watch(allOpenOpportunitiesProvider).valueOrNull ?? [];
    final bookmarked = allOpportunities.where((o) => bookmarkedIds.contains(o.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Opportunities')),
      body: bookmarked.isEmpty
          ? const Center(child: Text('No bookmarks yet.'))
          : ListView.builder(
              itemCount: bookmarked.length,
              itemBuilder: (context, index) {
                final opp = bookmarked[index];
                return OpportunityCard(
                  opportunity: opp,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => OpportunityDetailScreen(opportunity: opp)),
                  ),
                );
              },
            ),
    );
  }
}