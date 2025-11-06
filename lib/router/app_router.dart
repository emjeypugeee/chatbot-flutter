// lib/router/app_router.dart

import 'package:chatbot/animations/fade_out_page_transition.dart';
import 'package:chatbot/pages/chatbot_pages/chatbot_page.dart';
import 'package:chatbot/pages/login_pages/intro_page.dart';
import 'package:chatbot/pages/login_pages/login_page.dart';
import 'package:chatbot/pages/login_pages/register_page.dart';
import 'package:chatbot/pages/login_pages/welcome_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // 1. Change this from 'GoRouter router' to 'List<RouteBase> routes'
  static final List<RouteBase> routes = [
    // 2. Add a root path for the app to start on
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          FadeOutPageTransition(child: IntroPage(), key: state.pageKey),
    ),
    GoRoute(
      path: '/intro',
      pageBuilder: (context, state) =>
          FadeOutPageTransition(child: IntroPage(), key: state.pageKey),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) =>
          FadeOutPageTransition(child: WelcomePage(), key: state.pageKey),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          FadeOutPageTransition(child: RegisterPage(), key: state.pageKey),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          FadeOutPageTransition(child: LoginPage(), key: state.pageKey),
    ),
    GoRoute(
      path: '/chatbot',
      pageBuilder: (context, state) =>
          FadeOutPageTransition(child: ChatbotPage(), key: state.pageKey),
    ),
    // ... (your other routes)
  ];
}
