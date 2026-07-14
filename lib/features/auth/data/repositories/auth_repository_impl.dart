import '../../../../core/error/either.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    // STEP 1 — Always check connectivity BEFORE attempting the API call.
    // This is the "prevent the API call and show a proper message" rule
    // from the requirements: we never even touch Dio if there's no internet.
    final hasInternet = await networkInfo.isConnected;
    if (!hasInternet) {
      return const Left(NoInternetFailure(
        'No internet connection. Please check your network and try again.',
      ));
    }

    // STEP 2 — We have internet, so attempt the real request.
    try {
      final result = await remoteDataSource.login(email: email, password: password);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return const Left(UnknownFailure('Something went wrong. Please try again.'));
    }
  }
}
