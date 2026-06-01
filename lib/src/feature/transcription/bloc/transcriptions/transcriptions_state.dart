part of 'transcriptions_bloc.dart';

@Freezed()
sealed class const TranscriptionsState._() with _$TranscriptionsState {
  const factory idle(List<TranscriptionData> transcriptions, {required bool hasReachedMax}) = TranscriptionsIdle;

  const factory processing(List<TranscriptionData> transcriptions, {required bool hasReachedMax}) =
      TranscriptionsProcessing;

  const factory fetching(List<TranscriptionData> transcriptions, {required bool hasReachedMax}) =
      TranscriptionsFetching;

  const factory success(List<TranscriptionData> transcriptions, {required bool hasReachedMax}) = TranscriptionsSuccess;

  const factory failure(
    List<TranscriptionData> transcriptions, {
    required bool hasReachedMax,
    required AppException exception,
  }) = TranscriptionsFailure;

  bool get inProgress => this is TranscriptionsProcessing;
}
