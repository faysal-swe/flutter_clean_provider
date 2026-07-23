import 'package:go_router/go_router.dart';

import '../core/session/auth_session.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.login,
    // Simple auth guard: if there's no token and someone tries to deep-link
    // straight into /profile/:id, bounce them back to /login.
    redirect: (context, state) {
      final loggedIn = AuthSession.instance.isLoggedIn;
      final goingToLogin = state.matchedLocation == Routes.login;

      if (!loggedIn && !goingToLogin) return Routes.login;
      if (loggedIn && goingToLogin) return Routes.profilePath(2);
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 2;
          return ProfileScreen(userId: id);
        },
      ),
    ],
  );
}
