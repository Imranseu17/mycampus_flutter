import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/home_bloc.dart';
import '../../assignments/presentation/assignments_page.dart';
import '../../notices/presentation/notices_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../routine/presentation/routine_page.dart';
import 'dashboard_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.isDemo});

  final bool isDemo;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthBloc>();
      final uid = auth.status == AuthStatus.authenticated
          ? (authStateUserId(context))
          : 'demo';

      if (widget.isDemo) {
        context.read<HomeBloc>().add(const HomeDemoLoadRequested());
      } else {
        context.read<HomeBloc>().add(HomeLoadRequested(uid: uid));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    const pages = [
      DashboardPage(),
      RoutinePage(),
      AssignmentsPage(),
      NoticesPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Routine',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Notices',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
