part of 'remaining_bloc.dart';

@Freezed(copyWith: false)
sealed class RemainingEvent with _$RemainingEvent {
  const factory start() = _RemainingStarted;

  const factory decreaseTextRemaining(int symbols) = _RemainingTextDecreased;

  const factory decreaseImageRemaining() = _RemainingImageDecreased;

  const factory decreaseTranscriptionRemaining() = _RemainingTranscriptionDecreased;
}
