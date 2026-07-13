import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import '../application/startup_controller.dart';

class CreateStartupScreen extends ConsumerStatefulWidget {
  const CreateStartupScreen({super.key});

  @override
  ConsumerState<CreateStartupScreen> createState() => _CreateStartupScreenState();
}

class _CreateStartupScreenState extends ConsumerState<CreateStartupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _category = 'Software Development';

  final _categories = const [
    'Software Development',
    'Design',
    'Marketing',
    'Operations',
    'Research',
    'Business Analysis',
    'Content Creation',
    'Community Management',
  ];

  void _submit(String founderUid) {
    if (_formKey.currentState!.validate()) {
      ref.read(startupControllerProvider.notifier).createStartup(
            name: _nameController.text.trim(),
            description: _descController.text.trim(),
            category: _category,
            founderUid: founderUid,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProfileProvider).valueOrNull;
    final state = ref.watch(startupControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Register Your Startup')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Only ALU-recognized startups can post opportunities. '
                'Submit your details below — your startup will show as "Pending Verification" '
                'until an admin confirms it.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Startup Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a description' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 24),
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: user == null ? null : () => _submit(user.uid),
                      child: const Text('Submit Startup'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}