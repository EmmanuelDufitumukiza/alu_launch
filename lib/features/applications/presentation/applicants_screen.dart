import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/opportunity_model.dart';
import '../application/application_providers.dart';
import '../application/application_controller.dart';

class ApplicantsScreen extends ConsumerWidget {
  final OpportunityModel opportunity;
  const ApplicantsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicantsAsync = ref.watch(applicantsForOpportunityProvider(opportunity.id));

    return Scaffold(
      appBar: AppBar(title: Text('Applicants: ${opportunity.title}')),
      body: applicantsAsync.when(
        data: (applicants) {
          if (applicants.isEmpty) {
            return const Center(child: Text('No applicants yet.'));
          }
          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final app = applicants[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(app.coverNote),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(label: Text(app.status)),
                          const Spacer(),
                          if (app.status == 'pending') ...[
                            TextButton(
                              onPressed: () => ref
                                  .read(applicationControllerProvider.notifier)
                                  .setStatus(app.id, 'accepted'),
                              child: const Text('Accept'),
                            ),
                            TextButton(
                              onPressed: () => ref
                                  .read(applicationControllerProvider.notifier)
                                  .setStatus(app.id, 'rejected'),
                              child: const Text('Reject'),
                            ),
                          ],
                        ],
                      ),
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