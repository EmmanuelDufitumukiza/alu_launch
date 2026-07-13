import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../startup_profile/application/startup_providers.dart';
import '../../startup_profile/presentation/create_startup_screen.dart';
import '../../opportunities/presentation/my_opportunities_screen.dart';
import 'profile_screen.dart';

class StartupAdminHomeShell extends ConsumerStatefulWidget {
  const StartupAdminHomeShell({super.key});

  @override
  ConsumerState<StartupAdminHomeShell> createState() => _StartupAdminHomeShellState();
}

class _StartupAdminHomeShellState extends ConsumerState<StartupAdminHomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final startupAsync = ref.watch(myStartupProvider);

    return startupAsync.when(
      data: (startup) {
        if (startup == null) {
          // No startup registered yet — force onboarding first
          return const CreateStartupScreen();
        }

        final screens = [
          MyOpportunitiesScreen(startup: startup),
          const ProfileScreen(),
        ];

        return Scaffold(
          body: screens[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.rocket_launch), label: 'My Opportunities'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}