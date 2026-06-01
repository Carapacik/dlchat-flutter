part of 'frozen_rates_bloc.dart';

@Freezed(copyWith: false)
sealed class FrozenRatesEvent with _$FrozenRatesEvent {
  const factory start() = _FrozenRatesStarted;
}
