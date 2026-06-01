part of 'user_rate_bloc.dart';

@Freezed()
sealed class const UserRateState._() with _$UserRateState {
  const factory idle(UserRate? userRate) = UserRateIdle;

  const factory processing(UserRate? userRate) = UserRateProcessing;

  const factory success(UserRate? userRate) = UserRateSuccess;

  const factory failure(UserRate? userRate, {required AppException exception}) = UserRateFailure;

  bool get inProgress => this is UserRateProcessing;
}
