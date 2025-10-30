// lib/router/app_router.dart
import 'package:chatbot/animations/fade_out_page_transition.dart';
import 'package:chatbot/pages/chatbot_pages/chatbot_page.dart';
import 'package:chatbot/pages/login_pages/intro_page.dart';
import 'package:chatbot/pages/login_pages/login_page.dart';
import 'package:chatbot/pages/login_pages/register_page.dart';
import 'package:chatbot/pages/login_pages/welcome_page.dart';
import 'package:chatbot/pages/main_pages/home_page.dart';
import 'package:chatbot/pages/main_pages/notification_page.dart';
import 'package:chatbot/pages/main_pages/savings_page.dart';
import 'package:chatbot/pages/main_pages/settings_page.dart';
import 'package:chatbot/components/bottom_navigator.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/chatbot',
    routes: [
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
      ShellRoute(
        builder: (context, state, child) => BottomNavigator(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                FadeOutPageTransition(child: HomePage(), key: state.pageKey),
          ),
          GoRoute(
            path: '/savings',
            pageBuilder: (context, state) =>
                FadeOutPageTransition(child: SavingsPage(), key: state.pageKey),
          ),
          GoRoute(
            path: '/notification',
            pageBuilder: (context, state) => FadeOutPageTransition(
              child: NotificationPage(),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => FadeOutPageTransition(
              child: SettingsPage(),
              key: state.pageKey,
            ),
          ),
        ],
      ),
    ],
  );
}
