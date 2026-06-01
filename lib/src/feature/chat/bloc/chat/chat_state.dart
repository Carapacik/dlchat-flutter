part of 'chat_bloc.dart';

@Freezed()
sealed class const ChatState._() with _$ChatState {
  const factory idle({
    required Chat? chat,
    required List<Message> chatMessages,
    required bool isWaitingAnswer,
    required bool hasReachedMax,
  }) = ChatIdle;

  const factory processing({
    required Chat? chat,
    required List<Message> chatMessages,
    required bool isWaitingAnswer,
    required bool hasReachedMax,
  }) = ChatProcessing;

  const factory fetching({
    required Chat? chat,
    required List<Message> chatMessages,
    required bool isWaitingAnswer,
    required bool hasReachedMax,
  }) = ChatFetching;

  const factory success({
    required Chat? chat,
    required List<Message> chatMessages,
    required bool isWaitingAnswer,
    required bool hasReachedMax,
  }) = ChatSuccess;

  const factory failure({
    required Chat? chat,
    required List<Message> chatMessages,
    required bool isWaitingAnswer,
    required bool hasReachedMax,
    required AppException exception,
  }) = ChatFailure;

  bool get inProgress => this is ChatProcessing;

  bool get inFetch => this is ChatFetching;

  bool get isFailure => this is ChatFailure;
}
