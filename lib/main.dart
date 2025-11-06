import 'package:chatbot/provider/auth_provider.dart';
import 'package:chatbot/provider/chat_provider.dart';
import 'package:chatbot/themes/theme_provider.dart';
import 'package:chatbot/router/app_router.dart'; // Import the router
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// main.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Warning: .env file not found. Using empty API key.");
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

        // 1. AuthProvider provides the user data
        ChangeNotifierProvider(create: (context) => AuthProvider()),

        // 2. This ProxyProvider *listens* to AuthProvider
        //    and *builds* a ChatProvider
        ChangeNotifierProxyProvider<AuthProvider, ChatProvider>(
          // 'create' is called once. We start with no user.
          create: (context) => ChatProvider(
            userId: null, // Start with no user
            apiKey: dotenv.env['DEEPSEEK_API_KEY'] ?? '',
          ),

          // 'update' is called whenever AuthProvider changes
          // (e.g., after login or logout)
          update: (context, auth, previousChatProvider) {
            // Get the user ID (or null) from AuthProvider
            final userId = auth.currentUser?.uid;

            // Return a new ChatProvider with the updated userId
            return ChatProvider(
              userId: userId,
              apiKey: dotenv.env['DEEPSEEK_API_KEY'] ?? '',
            );
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);

    // 2. Create the GoRouter instance HERE
    final GoRouter router = GoRouter(
      // 3. Listen to the provider for login/logout changes
      refreshListenable: authProvider,

      // 4. Set the initial route
      initialLocation: '/',

      // 5. Use the static list of routes from your app_router.dart
      routes: AppRouter.routes,

      // 6. Add the redirect logic
      redirect: (BuildContext context, GoRouterState state) {
        final bool isLoggedIn = authProvider.isLoggedIn;

        // Define your pages that a logged-out user can see
        final bool isPublicRoute =
            state.matchedLocation == '/' ||
            state.matchedLocation == '/intro' ||
            state.matchedLocation == '/welcome' ||
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // --- Logic ---

        // If user is logged in and tries to go to a public/auth page,
        // send them to the chatbot.
        if (isLoggedIn && isPublicRoute) {
          return '/chatbot';
        }

        // If user is NOT logged in and tries to go to a protected page
        // (any page not in our public list), send them to the login page.
        if (!isLoggedIn && !isPublicRoute) {
          return '/login';
        }

        // Otherwise, allow navigation.
        return null;
      },
    );
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
        );
      },
    );
  }
}
