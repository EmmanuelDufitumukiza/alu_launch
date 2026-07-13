import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../application/opportunity_providers.dart';
import '../application/opportunity_controller.dart';
import 'post_opportunity_screen.dart';
import '../../applications/presentation/applicants_screen.dart';

class MyOpportunitiesScreen extends ConsumerWidget {
  final StartupModel startup;
  const MyOpportunitiesScreen({super.key, required this.startup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opportunitiesAsync = ref.watch(myPostedOpportunitiesProvider(startup.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Opportunities'),
        actions: [
          if (!startup.verified)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(child: Text('Pending Verification', style: TextStyle(color: Colors.orange))),
            ),
        ],
      ),
      floatingActionButton: startup.verified
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PostOpportunityScreen(startup: startup)),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: opportunitiesAsync.when(
        data: (opportunities) {
          if (opportunities.isEmpty) {
            return const Center(child: Text('No opportunities posted yet.'));
          }
          return ListView.builder(
            itemCount: opportunities.length,
            itemBuilder: (context, index) {
              final opp = opportunities[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(opp.title),
                  subtitle: Text('${opp.roleType} • ${opp.status}'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ApplicantsScreen(opportunity: opp),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'close') {
                        ref.read(opportunityControllerProvider.notifier).closeOpportunity(opp.id);
                      } else if (value == 'delete') {
                        ref.read(opportunityControllerProvider.notifier).deleteOpportunity(opp.id);
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'close', child: Text('Mark as Closed')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}