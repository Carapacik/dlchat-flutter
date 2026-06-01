part of 'chats_bloc.dart';

@Freezed(copyWith: false)
sealed class ChatsEvent with _$ChatsEvent {
  const factory start() = _ChatsStarted;

  const factory fetched() = _ChatsFetched;

  const factory addChat({
    required String chatModelId,
    required bool useContext,
    ChatType? modelType,
    String? name,
    String? presetId,
  }) = _ChatsAdded;

  const factory addAssistant({
    required AssistantType assistantType,
    required String name,
    required String initialMessage,
  }) = _ChatsAddedAssistant;

  const factory removeChat(String id) = _ChatsRemoved;

  const factory clearChat(String id) = _ChatsCleared;

  const factory renameChat(String id, String name) = _ChatsRenamed;

  const factory moveToTop(String id) = _ChatsMovedToTop;
}
