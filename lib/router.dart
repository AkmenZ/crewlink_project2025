import 'package:crewlink/pages/auth_page.dart';
import 'package:crewlink/pages/home_page.dart';
import 'package:crewlink/pages/loading_page.dart';
import 'package:crewlink/pages/profile_page.dart';
import 'package:crewlink/pages/radar_page.dart';
import 'package:crewlink/widgets/shell_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// listen to auth state changes
class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }
}

final router = GoRouter(
  initialLocation: '/home',
  refreshListenable: AuthStateNotifier(), // auth state chage listener
  redirect: (context, state) {
    // checks if user is logged in
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    
    // if not logged in and not on auth route, navigate user to /auth
    if (!isLoggedIn && state.matchedLocation != '/auth') {
      return '/auth';
    }
    
    // if logged in and on auth route, navigate to /home
    if (isLoggedIn && state.matchedLocation == '/auth') {
      return '/home';
    }

    // else return
    return null;
  },
  
  routes: <RouteBase>[
    // auth page
    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthPage(),
    ),
    // loading page
    GoRoute(
      path: '/loading',
      builder: (context, state) => LoadingPage(),
    ),
    // shell router pages will display common bottom nav bar
    ShellRoute(
      builder: (context, state, child) {
        return ShellNav(child: child);
      },
      routes: <RouteBase>[
        // home page
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        // radar page
        GoRoute(
          path: '/radar',
          builder: (context, state) => RadarPage(),
        ),
        // profile page
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfilePage(),
        ),
      ],
    ),
  ],
);
