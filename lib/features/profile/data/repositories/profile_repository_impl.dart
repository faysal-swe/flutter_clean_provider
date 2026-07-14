import '../../../../core/error/either.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(int userId) async {
    // Same "check connectivity first" rule as the auth repository.
    final hasInternet = await networkInfo.isConnected;
    if (!hasInternet) {
      return const Left(NoInternetFailure(
        'No internet connection. Please check your network and try again.',
      ));
    }

    try {
      final result = await remoteDataSource.getProfile(userId);
      return Right(result);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return const Left(UnknownFailure('Something went wrong. Please try again.'));
    }
  }
}
