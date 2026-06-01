import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/feature/chat/model/add_chat.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/chat_model.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rest_client/chat/chat_client.dart';
import 'package:rest_client/chat/dto/add_chat_command.dart';
import 'package:rest_client/chat/dto/rename_chat_command.dart';
import 'package:rest_client/chat_v2/chat_v2_client.dart';
import 'package:rest_client/chat_v2/dto/add_chat_v2_response.dart';
import 'package:rest_client/chat_v2/dto/add_nutritionist_chat_command.dart';
import 'package:rest_client/chat_v2/dto/add_simple_chat_command.dart';
import 'package:rest_client/chat_v2/dto/assistant_type.dart';
import 'package:rest_client/file/file_client.dart';
import 'package:rest_client/result_response.dart';

abstract interface class IChatRepository() {
  Future<Message> sendMessage({
    required String chatId,
    required bool isSearch,
    String? text,
    XFile? file,
    XFile? audio,
  });

  Future<List<Chat>> getChats({int offset = 0});

  Future<List<Assistant>> getAssistants();

  Future<AddChat> addChat({required String chatModelId, String? name, String? presetId, bool? useContext});

  Future<String> addChatV2({
    required AssistantType assistantType,
    String? name,
    String? initialMessage,
    bool useContext = true,
  });

  Future<Chat> getChat(String chatId);

  Future<void> deleteChat(String chatId);

  Future<void> cleanChat(String chatId);

  Future<void> renameChat({required String chatId, required String newName});

  Future<List<Message>> getChatMessages(String chatId, {int offset = 0});

  Future<List<ChatModel>> getChatModels();

  Future<ChatModel> getChatModel(String modelId);
}

final class const ChatRepository({
  required final ChatClient _chatClient,
  required final ChatV2Client _chatV2Client,
  required final SendFileClient _sendFileClient,
}) implements IChatRepository {
  @override
  Future<List<Chat>> getChats({int offset = 0}) =>
      _chatV2Client.getChats(offset: offset).then((dto) => dto.result.chats.map(Chat.decode).toList());

  @override
  Future<List<Assistant>> getAssistants() =>
      _chatClient.getAssistants().then((dto) => dto.result.assistants.map(Assistant.decode).toList());

  @override
  Future<Chat> getChat(String chatId) => _chatV2Client.getChat(chatId: chatId).then((dto) => Chat.decode(dto.result));

  @override
  Future<List<Message>> getChatMessages(String chatId, {int offset = 0}) => _chatClient
      .getChatMessages(chatId: chatId, offset: offset)
      .then((dto) => dto.result.messages.map(Message.decode).toList());

  @override
  Future<AddChat> addChat({required String chatModelId, String? name, String? presetId, bool? useContext}) =>
      _chatClient
          .addChat(
            body: AddChatCommand(chatModelId: chatModelId, name: name, presetId: presetId, useContext: useContext),
          )
          .then((dto) => AddChat.decode(dto.result));

  @override
  Future<String> addChatV2({
    required AssistantType assistantType,
    String? name,
    String? initialMessage,
    bool useContext = true,
  }) {
    final Future<ResultResponse<AddChatV2Response>> result = switch (assistantType) {
      AssistantType.nutritionist => _chatV2Client.addNutritionistChat(
        body: AddNutritionistChatCommand(
          assistantType: assistantType,
          name: name,
          useContext: useContext,
          initialMessage: initialMessage ?? '',
        ),
      ),
      AssistantType.image => _chatV2Client.addChat(
        body: AddSimpleChatCommand(assistantType: assistantType, name: name, useContext: useContext),
      ),
      _ => _chatV2Client.addChat(
        body: AddSimpleChatCommand(assistantType: assistantType, name: name, useContext: useContext),
      ),
    };

    return result.then((dto) => dto.result.id);
  }

  @override
  Future<void> deleteChat(String chatId) => _chatClient.deleteChat(chatId: chatId);

  @override
  Future<void> cleanChat(String chatId) => _chatClient.cleanChat(chatId: chatId);

  @override
  Future<void> renameChat({required String chatId, required String newName}) => _chatClient.renameChat(
    chatId: chatId,
    body: RenameChatCommand(name: newName),
  );

  @override
  Future<List<ChatModel>> getChatModels() =>
      _chatClient.getChatModels().then((dto) => dto.result.models.map(ChatModel.decode).toList());

  @override
  Future<ChatModel> getChatModel(String modelId) =>
      _chatClient.getChatModel(modelId: modelId).then((dto) => ChatModel.decode(dto.result));

  @override
  Future<Message> sendMessage({
    required String chatId,
    required bool isSearch,
    String? text,
    XFile? file,
    XFile? audio,
  }) => _sendFileClient
      .sendMessage(useBytes: kIsWeb, chatId: chatId, isSearch: isSearch, text: text, file: file, audio: audio)
      .then((dto) => Message.decodeAnswer(dto.result));
}
