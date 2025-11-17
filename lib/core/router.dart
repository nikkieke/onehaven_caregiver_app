import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:onehaven_caregiver_app/core/shared_prefs.dart';
import 'package:onehaven_caregiver_app/presentation/views/dashboard_screen.dart';
import 'package:onehaven_caregiver_app/presentation/views/login_screen.dart';

final GlobalKey<NavigatorState> rootNavigation = GlobalKey(debugLabel: 'root');

final goRouterProvider = Provider((ref) {
  final sharedPreferences = ref.watch(sharedPrefProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigation,
    debugLogDiagnostics: true,
    restorationScopeId: 'app',
    redirect: (context, state) async {
      final token = await sharedPreferences.getString('token');
      if (token != null) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.login.name,
        builder: (context, state) => LoginScreen(),
      ),

      GoRoute(
        path: '/dashboard',
        name: AppRoute.dashboard.name,
        builder: (context, state) => DashboardScreen(),
      ),
    ],
  );
});

enum AppRoute { login, dashboard }
