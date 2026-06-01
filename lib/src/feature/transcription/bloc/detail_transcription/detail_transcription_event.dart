part of 'detail_transcription_bloc.dart';

@Freezed(copyWith: false)
sealed class DetailTranscriptionEvent with _$DetailTranscriptionEvent {
  const factory start() = _DetailTranscriptionStarted;

  const factory fetch() = _DetailTranscriptionFetched;
}
