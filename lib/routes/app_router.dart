import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/auth_service.dart';
import '../core/constants/qenet.dart';
import '../features/landing/landing_screen.dart';
import '../features/home/home_screen.dart';
import '../features/course/course_screen.dart';
import '../features/course/chapter_screen.dart';
import '../features/daily/daily_plan_screen.dart';
import '../features/exam/practical_exam_screen.dart';
import '../features/auth/oauth_callback_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/exercise/exercise_screen.dart';
import '../features/free_play/free_play_screen.dart';
import '../features/tuning/tuning_screen.dart';
import '../features/mezmur_tenat/mezmur_tenat_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/training_plan/training_plan_screen.dart';
import '../features/shop/shop_screen.dart';
import '../features/shop/cart_screen.dart';
import '../features/leaderboard/leaderboard_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  refreshListenable: authService,
  redirect: (context, state) {
    const open = {
      '/', '/home', '/about', '/contact', '/how-to-use',
      '/login', '/signup', '/try', '/shop', '/cart', '/auth/callback',
    };
    if (open.contains(state.uri.path) || authService.isSignedIn) return null;
    return '/login';
    // Paywall later: also require a paid account here, e.g.
    // if (!authService.hasSubscription) return '/subscribe';
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LandingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: HomeScreen(section: state.uri.queryParameters['section']),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ),
    GoRoute(
      path: '/try',
      builder: (context, state) => const FreePlayScreen(guest: true),
    ),
    GoRoute(
      path: '/course',
      builder: (context, state) => const CourseScreen(),
    ),
    GoRoute(
      path: '/course/:n',
      builder: (context, state) => ChapterScreen(
        key: ValueKey(state.uri.toString()),
        number: int.tryParse(state.pathParameters['n'] ?? '') ?? 1,
        initialTab: switch (state.uri.queryParameters['tab']) {
          'quiz' => 1,
          'assignment' => 2,
          _ => 0,
        },
      ),
    ),
    GoRoute(
      path: '/lessons',
      redirect: (context, state) => '/course',
    ),
    GoRoute(
      path: '/daily-plan',
      builder: (context, state) => const DailyPlanScreen(),
    ),
    GoRoute(
      path: '/exam',
      builder: (context, state) => PracticalExamScreen(
        key: ValueKey(state.uri.toString()),
        qenet: _qenetFrom(state.uri.queryParameters['qenet']) ?? Qenet.selamta,
      ),
    ),
    GoRoute(
      path: '/auth/callback',
      builder: (context, state) => OAuthCallbackScreen(
        code: state.uri.queryParameters['code'],
        error: state.uri.queryParameters['error'],
      ),
    ),
    GoRoute(
      path: '/exercise',
      builder: (context, state) => ExerciseScreen(
        initialQenet: _qenetFrom(state.uri.queryParameters['qenet']),
      ),
    ),
    GoRoute(path: '/how-to-use', redirect: (context, state) => '/home?section=howTo'),
    GoRoute(path: '/about', redirect: (context, state) => '/home?section=about'),
    GoRoute(path: '/contact', redirect: (context, state) => '/home?section=contact'),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/free-play',
      builder: (context, state) => const FreePlayScreen(),
    ),
    GoRoute(
      path: '/tuning',
      builder: (context, state) => const TuningScreen(),
    ),
    GoRoute(
      path: '/mezmur-tenat',
      builder: (context, state) => const MezmurTenatScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/training-plan',
      builder: (context, state) => const TrainingPlanScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/leaderboard',
      builder: (context, state) => const LeaderboardScreen(),
    ),
  ],
);

Qenet? _qenetFrom(String? name) {
  for (final q in Qenet.values) {
    if (q.name == name) return q;
  }
  return null;
}
