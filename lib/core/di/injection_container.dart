import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

/// A deliberately simple, hand-written service locator.
///
/// We were not asked to use `get_it`, so instead of pulling in another
/// package this container just builds every dependency once, in the
/// correct order, and exposes the top-level things the UI needs
/// (the two Providers). This still gives us the exact same benefit
/// Clean Architecture wants from DI: every layer only depends on
/// abstractions, and swapping an implementation means editing ONE file.
class InjectionContainer {
  InjectionContainer._internal();
  static final InjectionContainer instance = InjectionContainer._internal();

  late final Dio dio;
  late final NetworkInfo networkInfo;

  // Auth feature
  late final AuthRemoteDataSource authRemoteDataSource;
  late final AuthRepository authRepository;
  late final LoginUseCase loginUseCase;
  late final AuthProvider authProvider;

  // Profile feature
  late final ProfileRemoteDataSource profileRemoteDataSource;
  late final ProfileRepository profileRepository;
  late final GetProfileUseCase getProfileUseCase;
  late final ProfileProvider profileProvider;

  bool _initialized = false;

  /// Call this once, before `runApp`.
  void init() {
    if (_initialized) return;
    _initialized = true;

    // ---- Core ----
    dio = DioClient.create();
    networkInfo = NetworkInfoImpl(InternetConnectionChecker());

    // ---- Auth feature ----
    authRemoteDataSource = AuthRemoteDataSourceImpl(dio: dio);
    authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      networkInfo: networkInfo,
    );
    loginUseCase = LoginUseCase(authRepository);
    authProvider = AuthProvider(loginUseCase: loginUseCase);

    // ---- Profile feature ----
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(dio: dio);
    profileRepository = ProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
      networkInfo: networkInfo,
    );
    getProfileUseCase = GetProfileUseCase(profileRepository);
    profileProvider = ProfileProvider(
      getProfileUseCase: getProfileUseCase,
      networkInfo: networkInfo,
    );
  }
}
