import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saber_cristao/features/auth/presentation/auth_controller.dart';
import 'package:saber_cristao/features/auth/presentation/auth_state.dart';
import 'package:saber_cristao/features/auth/presentation/forgot_password_screen.dart';
import 'package:saber_cristao/features/auth/presentation/login_screen.dart';
import 'package:saber_cristao/features/auth/presentation/register_screen.dart';
import 'package:saber_cristao/features/home/presentation/home_screen.dart';
import 'package:saber_cristao/features/home/presentation/splash_screen.dart';
import 'package:saber_cristao/features/levels/presentation/level_map_screen.dart';
import 'package:saber_cristao/features/lives/presentation/out_of_lives_screen.dart';
import 'package:saber_cristao/features/paywall/presentation/paywall_screen.dart';
import 'package:saber_cristao/features/quiz/domain/quiz_result_model.dart';
import 'package:saber_cristao/features/quiz/presentation/quiz_screen.dart';
import 'package:saber_cristao/features/quiz/presentation/result_screen.dart';
import 'package:saber_cristao/features/store/presentation/store_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = GoRouterRefreshStream(
    ref.watch(authControllerProvider.notifier).stream,
  );

  const publicRoutes = {'/login', '/register', '/forgot-password'};
  const protectedRoutes = {
    '/home',
    '/quiz',
    '/result',
    '/levels',
    '/out-of-lives',
    '/store',
    '/paywall',
    '/profile',
    '/settings',
  };

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.matchedLocation;

      if (authState.status == AuthStatus.loading) return null;

      final isAuthed = authState.status == AuthStatus.authenticated;
      if (!isAuthed && protectedRoutes.contains(location)) return '/login';
      if (!isAuthed && location == '/splash') return '/login';
      if (isAuthed && (publicRoutes.contains(location) || location == '/splash')) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (_, state) => const QuizScreen(),
      ),
      GoRoute(
        path: '/result',
        builder: (_, state) {
          final result = state.extra as QuizResultModel;
          return ResultScreen(result: result);
        },
      ),
      GoRoute(
        path: '/levels',
        builder: (_, state) => const LevelMapScreen(),
      ),
      GoRoute(
        path: '/out-of-lives',
        builder: (_, state) => const OutOfLivesScreen(),
      ),
      GoRoute(
        path: '/store',
        builder: (_, state) => const StoreScreen(),
      ),
      GoRoute(
        path: '/paywall',
        builder: (_, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, state) => const _SimpleScreen(title: 'Perfil'),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, state) => const _SimpleScreen(title: 'Configuracoes'),
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _SimpleScreen extends StatelessWidget {
  const _SimpleScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
