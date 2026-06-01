part of 'audio_message_bloc.dart';

@Freezed()
sealed class const AudioMessageState._() with _$AudioMessageState {
  const factory idle() = AudioMessageIdle;

  const factory processing() = AudioMessageProcessing;

  const factory success() = AudioMessageSuccess;

  const factory failure({required AppException exception}) = AudioMessageFailure;

  bool get inProgress => this is AudioMessageProcessing;
}
