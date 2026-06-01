part of 'chat_model_bloc.dart';

@Freezed()
sealed class const ChatModelState._() with _$ChatModelState {
  const factory idle(List<ChatModel> chatModels) = ChatModelIdle;

  const factory processing(List<ChatModel> chatModels) = ChatModelProcessing;

  const factory success(List<ChatModel> chatModels) = ChatModelSuccess;

  const factory failure(List<ChatModel> chatModels) = ChatModelFailure;
}
