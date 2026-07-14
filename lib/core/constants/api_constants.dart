/// All hard-coded API values live here so nothing is scattered
/// through data sources. Swap these for --dart-define values or a
/// .env file in a real production app.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://reqres.in/api';

  // reqres.in now requires an API key on the free tier.
  // Sent as a header on every request (see DioClient).
  static const String apiKey = 'free_user_3GTavnMhO0bk8ZgUgmJbe4DfrQl';

  static const String login = '/login';
  static String userById(int id) => '/users/$id';
  static const String users = '/users';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
