part of 'profile_bloc.dart';

@Freezed(copyWith: false)
sealed class ProfileEvent with _$ProfileEvent {
  const factory start() = _ProfileStarted;

  const factory deleteAccount() = _ProfileAccountDeleted;
}
