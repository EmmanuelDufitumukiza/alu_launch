import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/opportunity_providers.dart';
import '../../../core/widgets/opportunity_card.dart';
import 'opportunity_detail_screen.dart';

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredOpportunitiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discover Opportunities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by title, role, or startup',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  ref.read(opportunitySearchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: filtered.when(
              data: (opportunities) {
                if (opportunities.isEmpty) {
                  return const Center(child: Text('No opportunities found.'));
                }
                return ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    final opp = opportunities[index];
                    return OpportunityCard(
                      opportunity: opp,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OpportunityDetailScreen(opportunity: opp),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}