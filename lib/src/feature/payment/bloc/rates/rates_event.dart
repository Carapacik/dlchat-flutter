part of 'rates_bloc.dart';

@Freezed(copyWith: false)
sealed class RatesEvent with _$RatesEvent {
  const factory start() = _RatesStarted;
}
