part of 'audio_message_bloc.dart';

@Freezed(copyWith: false)
sealed class AudioMessageEvent with _$AudioMessageEvent {
  const factory sendFile({
    required XFile file,
    required bool isSearch,
    required void Function(Message) onTranscriptionComplete,
  }) = _AudioMessageSendFile;
}
