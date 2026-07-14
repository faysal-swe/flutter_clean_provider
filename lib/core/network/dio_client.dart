import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

/// Builds and configures the single [Dio] instance used by the whole app.
///
/// Responsibilities:
///  - base URL / timeouts
///  - attaching the API key header to every request
///  - request/response logging (pretty_dio_logger) - only useful in debug,
///    but harmless to leave on for this demo
class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': ApiConstants.apiKey,
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    return dio;
  }
}

/// Converts a [DioException] into one of our own [AppException]s.
///
/// This is the SINGLE place that interprets HTTP status codes, so every
/// data source calls this the same way instead of duplicating switch
/// statements everywhere.
AppException handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException();

    case DioExceptionType.connectionError:
      // Dio couldn't even open a socket - almost always "no internet"
      // or DNS failure, but we've already checked connectivity before
      // this call, so treat it as a server-reachability issue.
      return const ServerException(
        message: 'Could not reach the server. Please try again.',
      );

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 400:
          return const BadRequestException();
        case 401:
          return const UnauthorizedException();
        case 403:
          return const ForbiddenException();
        case 404:
          return const NotFoundException();
        case 500:
        case 502:
        case 503:
          return ServerException(statusCode: statusCode);
        default:
          return ServerException(
            statusCode: statusCode,
            message: 'Unexpected server response ($statusCode).',
          );
      }

    case DioExceptionType.cancel:
      return const UnknownException(message: 'Request was cancelled.');

    case DioExceptionType.badCertificate:
      return const UnknownException(message: 'Security certificate error.');

    case DioExceptionType.unknown:
      return const UnknownException();
    case DioExceptionType.transformTimeout:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}
