part of 'chat_model_bloc.dart';

@Freezed(copyWith: false)
sealed class ChatModelEvent with _$ChatModelEvent {
  const factory start() = _ChatModelStarted;
}
