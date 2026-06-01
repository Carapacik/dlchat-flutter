part of 'rates_bloc.dart';

@Freezed()
sealed class const RatesState._() with _$RatesState {
  const factory idle(List<Rate> rates) = RatesIdle;

  const factory processing(List<Rate> rates) = RatesProcessing;

  const factory success(List<Rate> rates) = RatesSuccess;

  const factory failure(List<Rate> rates, {required AppException exception}) = RatesFailure;

  bool get inProgress => this is RatesProcessing;
}
