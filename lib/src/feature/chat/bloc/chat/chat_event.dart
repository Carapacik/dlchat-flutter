part of 'chat_bloc.dart';

@Freezed(copyWith: false)
sealed class ChatEvent with _$ChatEvent {
  const factory start(String id) = _ChatStarted;

  const factory fetched() = _ChatFetched;

  const factory sendMessage({required String text, required bool isSearch, XFile? file}) = _ChatMessageSent;

  const factory deleteChat(String id) = _ChatDeleted;

  const factory clearChat(String id) = _ChatCleared;

  const factory renameChat(String id, String name) = _ChatRenamed;

  const factory addAudioMessage(Message audioMessage) = _ChatAudioMessageAdded;
}
