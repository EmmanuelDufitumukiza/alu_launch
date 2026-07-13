import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/startup_model.dart';
import '../application/opportunity_controller.dart';

class PostOpportunityScreen extends ConsumerStatefulWidget {
  final StartupModel startup;
  const PostOpportunityScreen({super.key, required this.startup});

  @override
  ConsumerState<PostOpportunityScreen> createState() => _PostOpportunityScreenState();
}

class _PostOpportunityScreenState extends ConsumerState<PostOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _commitmentController = TextEditingController();
  String _roleType = 'Software Development';

  final _roles = const [
    'Software Development',
    'Design',
    'Marketing',
    'Operations',
    'Research',
    'Business Analysis',
    'Content Creation',
    'Community Management',
  ];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(opportunityControllerProvider.notifier).postOpportunity(
            startupId: widget.startup.id,
            startupName: widget.startup.name,
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            roleType: _roleType,
            commitment: _commitmentController.text.trim(),
          );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(opportunityControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Post Opportunity')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a description' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _roleType,
                decoration: const InputDecoration(labelText: 'Role Type'),
                items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _roleType = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commitmentController,
                decoration: const InputDecoration(labelText: 'Commitment (e.g. 5 hrs/week)'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a commitment' : null,
              ),
              const SizedBox(height: 24),
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(onPressed: _submit, child: const Text('Post')),
            ],
          ),
        ),
      ),
    );
  }
}