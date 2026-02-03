import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/title/title_screen.dart';
import '../presentation/screens/team_select/team_select_screen.dart';
import '../presentation/screens/main_menu/main_menu_screen.dart';
import '../presentation/screens/roster_select/roster_select_screen.dart';
import '../presentation/screens/match_simulation/match_simulation_screen.dart';
import '../presentation/screens/save_load/save_load_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'title',
        builder: (context, state) => const TitleScreen(),
      ),
      GoRoute(
        path: '/team-select',
        name: 'teamSelect',
        builder: (context, state) => const TeamSelectScreen(),
      ),
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: '/roster-select',
        name: 'rosterSelect',
        builder: (context, state) => const RosterSelectScreen(),
      ),
      GoRoute(
        path: '/match',
        name: 'match',
        builder: (context, state) => const MatchSimulationScreen(),
      ),
      GoRoute(
        path: '/save-load',
        name: 'saveLoad',
        builder: (context, state) => const SaveLoadScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});
