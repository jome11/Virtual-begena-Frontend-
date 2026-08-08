import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/landing/landing_screen.dart';
import '../features/home/home_screen.dart';
import '../features/about/about_screen.dart';
import '../features/contact/contact_screen.dart';
import '../features/lessons/lessons_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/exercise/exercise_screen.dart';
import '../features/free_play/free_play_screen.dart';
import '../features/tuning/tuning_screen.dart';
import '../features/mezmur_tenat/mezmur_tenat_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/training_plan/training_plan_screen.dart';
import '../features/real_play/real_play_screen.dart';
import '../features/shop/shop_screen.dart';
import '../features/shop/cart_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
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
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ),
    GoRoute(
      path: '/lessons',
      builder: (context, state) => const LessonsScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
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
      path: '/exercise',
      builder: (context, state) => const ExerciseScreen(),
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
      path: '/real-play',
      builder: (context, state) => const RealPlayScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);
