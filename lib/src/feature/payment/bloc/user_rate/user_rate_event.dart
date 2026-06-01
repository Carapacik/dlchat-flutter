part of 'user_rate_bloc.dart';

@Freezed(copyWith: false)
sealed class UserRateEvent with _$UserRateEvent {
  const factory start() = _UserRateStarted;

  const factory update() = _UserRateUpdated;
}
