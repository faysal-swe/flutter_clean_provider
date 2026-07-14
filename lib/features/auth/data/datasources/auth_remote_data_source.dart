import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_model.dart';

/// Data source contract - only concerned with "how do I get an AuthModel
/// from the remote server", nothing about connectivity or Failures.
/// Connectivity is checked one layer up, in the repository.
abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return AuthModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      // Convert Dio's error into one of OUR exceptions (see dio_client.dart).
      // reqres.in returns 400 with {"error": "..."} for bad login attempts,
      // which will surface here as a BadRequestException.
      throw handleDioException(e);
    }
  }
}
