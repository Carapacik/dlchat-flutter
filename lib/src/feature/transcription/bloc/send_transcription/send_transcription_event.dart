part of 'send_transcription_bloc.dart';

@Freezed(copyWith: false)
sealed class SendTranscriptionEvent with _$SendTranscriptionEvent {
  const factory sendFile(XFile file) = _SendTranscriptionSendFile;

  const factory sendUrl(String url) = _SendTranscriptionSendUrl;

  const factory startExtractAudio() = _SendTranscriptionStartExtractAudio;
}
