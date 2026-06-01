// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rest_client/chat/dto/add_chat_command.dart';
import 'package:rest_client/chat/dto/add_chat_dto.dart';
import 'package:rest_client/chat/dto/assistants_dto.dart';
import 'package:rest_client/chat/dto/audio_chat_message_dto.dart';
import 'package:rest_client/chat/dto/chat_dto.dart';
import 'package:rest_client/chat/dto/chat_message_dto.dart';
import 'package:rest_client/chat/dto/chat_messages_dto.dart';
import 'package:rest_client/chat/dto/chat_model_dto.dart';
import 'package:rest_client/chat/dto/chat_models_dto.dart';
import 'package:rest_client/chat/dto/chat_type_dto.dart';
import 'package:rest_client/chat/dto/chats_dto.dart';
import 'package:rest_client/chat/dto/rename_chat_command.dart';
import 'package:rest_client/chat/dto/send_chat_message_command.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_client.g.dart';

@RestApi()
abstract class ChatClient {
  factory ChatClient(Dio dio, {String? baseUrl}) = _ChatClient;

  /// Get Chats.
  ///
  /// Получить чаты.
  ///
  /// [limit] - Лимит.
  ///
  /// [offset] - Оффсет.
  @GET('/v1/chats/')
  Future<ResultResponse<ChatsDto>> getChats({@Query('limit') int limit = 20, @Query('offset') int offset = 0});

  /// Get Assistant.
  ///
  /// Получить помощников.
  @GET('/v1/chats/assistant')
  Future<ResultResponse<AssistantsDto>> getAssistants();

  /// Add Chat.
  ///
  /// Добавить чат.
  @POST('/v1/chats/')
  Future<ResultResponse<AddChatDto>> addChat({@Body() required AddChatCommand body});

  /// Get Chat.
  ///
  /// Получить чат.
  ///
  /// [chatId] - Идентификатор чата.
  @GET('/v1/chats/{chatId}')
  Future<ResultResponse<ChatDto>> getChat({@Path('chatId') required String chatId});

  /// Delete Chat.
  ///
  /// Удалить чат.
  ///
  /// [chatId] - Идентификатор чата.
  @DELETE('/v1/chats/{chatId}')
  Future<void> deleteChat({@Path('chatId') required String chatId});

  /// Get Chat Messages.
  ///
  /// Получить все сообщения чата.
  ///
  /// [chatId] - Идентификатор чата.
  ///
  /// [limit] - Лимит.
  ///
  /// [offset] - Оффсет.
  @GET('/v1/chats/{chatId}/messages')
  Future<ResultResponse<ChatMessagesDto>> getChatMessages({
    @Path('chatId') required String chatId,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  /// Clean Chat.
  ///
  /// Отчистить чат.
  ///
  /// [chatId] - Идентификатор чата.
  @POST('/v1/chats/{chatId}/clean')
  Future<void> cleanChat({@Path('chatId') required String chatId});

  /// Rename Chat.
  ///
  /// Переименовать чат.
  ///
  /// [chatId] - Идентификатор чата.
  @PUT('/v1/chats/{chatId}/rename')
  Future<void> renameChat({@Path('chatId') required String chatId, @Body() required RenameChatCommand body});

  /// Send Audio Message.
  ///
  /// Отправить аудио сообщение в чат.
  ///
  /// [chatId] - Идентификатор чата.
  ///
  /// [audio] - Голосовое сообщение.
  @MultiPart()
  @POST('/v1/chats/{chatId}/audioMessage')
  Future<ResultResponse<AudioChatMessageDto>> sendAudio({
    @Path('chatId') required String chatId,
    @Part(name: 'isSearch') bool isSearch = false,
    @Part(name: 'audio') required File audio,
  });

  /// Get Chat Models.
  ///
  /// Получение моделей.
  ///
  /// [limit] - Лимит.
  ///
  /// [offset] - Оффсет.
  ///
  /// [modelType] - Тип модели.
  @GET('/v1/chats/chatModel/')
  Future<ResultResponse<ChatModelsDto>> getChatModels({
    @Query('modelType') ChatTypeDto? modelType,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  /// Get Chat Model.
  ///
  /// Получение модели.
  ///
  /// [modelId] - Идентификатор модели.
  @GET('/v1/chats/chatModel/{modelId}')
  Future<ResultResponse<ChatModelDto>> getChatModel({@Path('modelId') required String modelId});
}
