part of 'chats_bloc.dart';

@Freezed()
sealed class const ChatsState._() with _$ChatsState {
  const factory idle(
    List<Chat> chats,
    List<Assistant> assistants, {
    required bool hasReachedMax,
    Chat? newChat,
    Chat? existingChat,
  }) = ChatsIdle;

  const factory processing(
    List<Chat> chats,
    List<Assistant> assistants, {
    required bool hasReachedMax,
    Chat? newChat,
    Chat? existingChat,
  }) = ChatsProcessing;

  const factory fetching(
    List<Chat> chats,
    List<Assistant> assistants, {
    required bool hasReachedMax,
    Chat? newChat,
    Chat? existingChat,
  }) = ChatsFetching;

  const factory addProcessing(
    List<Chat> chats,
    List<Assistant> assistants, {
    required bool hasReachedMax,
    Chat? newChat,
    Chat? existingChat,
  }) = ChatsAddProcessing;

  const factory success(
    List<Chat> chats,
    List<Assistant> assistants, {
    required bool hasReachedMax,
    Chat? newChat,
    Chat? existingChat,
  }) = ChatsSuccess;

  const factory failure(
    List<Chat> chats,
    List<Assistant> assistants, {
    required bool hasReachedMax,
    required AppException exception,
    Chat? newChat,
    Chat? existingChat,
  }) = ChatsFailure;

  bool get inProgress => this is ChatsProcessing;

  bool get inAddProgress => this is ChatsAddProcessing;
}
