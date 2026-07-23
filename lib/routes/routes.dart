final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  static const String login = '/login';
  static const String profile = '/profile/:id';

  // Dynamic route path builder
  static String profilePath(Object id) => '/profile/$id';
}
