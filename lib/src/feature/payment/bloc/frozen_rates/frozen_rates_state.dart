part of 'frozen_rates_bloc.dart';

@Freezed()
sealed class const FrozenRatesState._() with _$FrozenRatesState {
  const factory idle(List<UserRate> rates) = FrozenRatesIdle;

  const factory processing(List<UserRate> rates) = FrozenRatesProcessing;

  const factory success(List<UserRate> rates) = FrozenRatesSuccess;

  const factory failure(List<UserRate> rates, {required AppException exception}) = FrozenRatesFailure;
}
