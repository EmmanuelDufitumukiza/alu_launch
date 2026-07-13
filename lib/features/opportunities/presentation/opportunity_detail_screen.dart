import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/opportunity_model.dart';
import '../../auth/application/auth_providers.dart';
import '../../applications/application/application_controller.dart';

class OpportunityDetailScreen extends ConsumerStatefulWidget {
  final OpportunityModel opportunity;
  const OpportunityDetailScreen({super.key, required this.opportunity});

  @override
  ConsumerState<OpportunityDetailScreen> createState() => _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends ConsumerState<OpportunityDetailScreen> {
  final _coverNoteController = TextEditingController();

  Future<void> _showApplyDialog() async {
    final user = ref.read(currentUserProfileProvider).valueOrNull;
    if (user == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply to this opportunity'),
        content: TextField(
          controller: _coverNoteController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Briefly say why you\'re a good fit...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final error = await ref.read(applicationControllerProvider.notifier).applyToOpportunity(
                    opportunityId: widget.opportunity.id,
                    opportunityTitle: widget.opportunity.title,
                    studentUid: user.uid,
                    studentName: user.name,
                    coverNote: _coverNoteController.text.trim(),
                  );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error ?? 'Application submitted!')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opp = widget.opportunity;
    return Scaffold(
      appBar: AppBar(title: Text(opp.title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opp.startupName, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, children: [
              Chip(label: Text(opp.roleType)),
              Chip(label: Text(opp.commitment)),
            ]),
            const SizedBox(height: 20),
            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(opp.description),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showApplyDialog,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}