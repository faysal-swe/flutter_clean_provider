import 'package:go_router/go_router.dart';

import '../core/session/auth_session.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    // Simple auth guard: if there's no token and someone tries to deep-link
    // straight into /profile/:id, bounce them back to /login.
    redirect: (context, state) {
      final loggedIn = AuthSession.instance.isLoggedIn;
      final goingToLogin = state.matchedLocation == '/login';

      if (!loggedIn && !goingToLogin) return '/login';
      if (loggedIn && goingToLogin) return '/profile/2';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 2;
          return ProfileScreen(userId: id);
        },
      ),
    ],
  );
}
