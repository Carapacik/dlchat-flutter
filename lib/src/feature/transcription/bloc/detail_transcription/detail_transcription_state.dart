part of 'detail_transcription_bloc.dart';

@Freezed()
sealed class const DetailTranscriptionState._() with _$DetailTranscriptionState {
  const factory idle(List<TranscriptionMessage> messages, {required bool hasReachedMax}) = DetailTranscriptionIdle;

  const factory processing(List<TranscriptionMessage> messages, {required bool hasReachedMax}) =
      DetailTranscriptionProcessing;

  const factory fetching(List<TranscriptionMessage> messages, {required bool hasReachedMax}) =
      DetailTranscriptionFetching;

  const factory success(List<TranscriptionMessage> messages, {required bool hasReachedMax}) =
      DetailTranscriptionSuccess;

  const factory failure(
    List<TranscriptionMessage> messages, {
    required bool hasReachedMax,
    required AppException exception,
  }) = DetailTranscriptionFailure;

  bool get inProgress => this is DetailTranscriptionProcessing;
}
