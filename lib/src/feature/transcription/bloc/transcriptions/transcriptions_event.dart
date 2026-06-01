part of 'transcriptions_bloc.dart';

@Freezed(copyWith: false)
sealed class TranscriptionsEvent with _$TranscriptionsEvent {
  const factory start() = _TranscriptionsStarted;

  const factory fetch() = _TranscriptionsFetched;

  const factory poll() = _TranscriptionsPoll;

  const factory rename(String id, String name) = _TranscriptionsRenamed;

  const factory delete(String id) = _TranscriptionsDeleted;
}
