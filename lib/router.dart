import 'package:crewlink/pages/auth_page.dart';
import 'package:crewlink/pages/home_page.dart';
import 'package:crewlink/pages/invitation_page.dart';
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
    // preprocess incoming URI to strip the scheme, if present
    final uri = state.uri;
    // if the URI has a scheme (like crewlink://), it's a deep link that needs to be processed
    if (uri.hasScheme) {
      final newPath = '/invite${uri.path}'; // with /invite prefic
      final rebuiltPath = newPath + (uri.hasQuery ? '?${uri.query}' : '');
      // return the rebuilt path
      return rebuiltPath;
    } 

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

    // if user is not logged in and trying to access /invite link without auth, redirect to /auth
    if (!isLoggedIn && state.matchedLocation.startsWith('/invite/')) {
      return '/auth';
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
    // invite page (for deep-links outside the shell)
    GoRoute(
      path: '/invite/:eventGroupId',
      builder: (context, state) => InvitationPage(
        eventGroupId: state.pathParameters['eventGroupId'] ?? '',
      ),
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
