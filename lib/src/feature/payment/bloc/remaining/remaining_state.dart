part of 'remaining_bloc.dart';

@Freezed()
sealed class const RemainingState._() with _$RemainingState {
  const factory idle(RemainingRequests? remaining) = RemainingIdle;

  const factory processing(RemainingRequests? remaining) = RemainingProcessing;

  const factory success(RemainingRequests? remaining) = RemainingSuccess;

  const factory failure(RemainingRequests? remaining, {required AppException exception}) = RemainingFailure;

  bool get inProgress => this is RemainingProcessing;
}
