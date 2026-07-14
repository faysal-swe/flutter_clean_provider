import 'package:flutter/foundation.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';

enum ProfileStatus { idle, loading, success, error }

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final NetworkInfo networkInfo;

  ProfileProvider({required this.getProfileUseCase, required this.networkInfo});

  ProfileStatus status = ProfileStatus.idle;
  ProfileEntity? profile;
  String? errorMessage;

  /// Tracks whether the most recent failure was specifically due to
  /// no internet. This is the flag that powers the requirement:
  /// "if the API failed due to no internet, automatically retry it
  /// when internet is back AND the user opens that screen again."
  bool _lastFailureWasNetwork = false;

  bool get isLoading => status == ProfileStatus.loading;

  /// The actual API call. Can be triggered by initial load, pull-to-refresh,
  /// or the retry button.
  Future<void> fetchProfile(int userId) async {
    status = ProfileStatus.loading;
    errorMessage = null;
    notifyListeners();

    final result = await getProfileUseCase(GetProfileParams(userId));

    result.fold(
      (failure) {
        status = ProfileStatus.error;
        errorMessage = failure.message;
        _lastFailureWasNetwork = failure is NoInternetFailure;
        notifyListeners();
      },
      (data) {
        profile = data;
        status = ProfileStatus.success;
        _lastFailureWasNetwork = false;
        notifyListeners();
      },
    );
  }

  /// Call this from the screen's `initState` (i.e. "the user opened this
  /// screen"). It implements the required behavior precisely:
  ///
  ///  - First time opening (idle, no data yet) -> just fetch.
  ///  - Previously failed for a NON-network reason (e.g. 404/500) -> do
  ///    nothing automatically; let the user tap Retry so we don't hammer
  ///    a broken endpoint.
  ///  - Previously failed because of NO INTERNET -> check connectivity
  ///    again right now; if it's back, automatically re-run the request.
  ///    If still offline, leave the existing error state as-is.
  Future<void> onScreenOpened(int userId) async {
    if (status == ProfileStatus.idle) {
      await fetchProfile(userId);
      return;
    }

    if (status == ProfileStatus.error && _lastFailureWasNetwork) {
      final backOnline = await networkInfo.isConnected;
      if (backOnline) {
        await fetchProfile(userId);
      }
      // else: still offline, keep showing the existing "no internet" error.
    }
  }

  void reset() {
    status = ProfileStatus.idle;
    profile = null;
    errorMessage = null;
    _lastFailureWasNetwork = false;
    notifyListeners();
  }
}
