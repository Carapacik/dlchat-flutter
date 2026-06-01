part of 'send_transcription_bloc.dart';

@Freezed()
sealed class const SendTranscriptionState._() with _$SendTranscriptionState {
  const factory idle() = SendTranscriptionIdle;

  const factory uploading({double? progress, @Default(false) bool extractingVideo}) = SendTranscriptionUploading;

  const factory success() = SendTranscriptionSuccess;

  const factory failure({required AppException exception}) = SendTranscriptionFailure;
}
