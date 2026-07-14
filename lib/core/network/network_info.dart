import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstraction over "do we actually have internet right now".
///
/// We deliberately use `internet_connection_checker` (which pings a real
/// host) instead of `connectivity_plus` alone, because being connected to
/// Wi-Fi doesn't guarantee there's actually internet access.
abstract class NetworkInfo {
  Future<bool> get isConnected;

  /// Stream of connectivity status changes — used by screens/providers
  /// to know the instant the connection comes back.
  Stream<InternetConnectionStatus> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> get onStatusChange => connectionChecker.onStatusChange;
}
