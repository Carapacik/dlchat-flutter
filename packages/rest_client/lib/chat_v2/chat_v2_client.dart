import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rest_client/chat/dto/chat_dto.dart';
import 'package:rest_client/chat/dto/chat_message_dto.dart';
import 'package:rest_client/chat/dto/chats_dto.dart';
import 'package:rest_client/chat_v2/dto/add_chat_v2_response.dart';
import 'package:rest_client/chat_v2/dto/add_nutritionist_chat_command.dart';
import 'package:rest_client/chat_v2/dto/add_simple_chat_command.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_v2_client.g.dart';

@RestApi()
abstract class ChatV2Client {
  factory(Dio dio, {String? baseUrl}) = _ChatV2Client;

  /// Get Chats.
  ///
  /// Получить чаты.
  ///
  /// [limit] - Лимит.
  ///
  /// [offset] - Оффсет.
  @GET('/v2/chats/')
  Future<ResultResponse<ChatsDto>> getChats({@Query('limit') int limit = 30, @Query('offset') int offset = 0});

  /// Add Chat.
  ///
  /// Добавить чат.
  @POST('/v2/chats/')
  Future<ResultResponse<AddChatV2Response>> addChat({@Body() required AddSimpleChatCommand body});

  /// Add Nutritionist Chat.
  ///
  /// Добавить чат.
  @POST('/v2/chats/')
  Future<ResultResponse<AddChatV2Response>> addNutritionistChat({@Body() required AddNutritionistChatCommand body});

  /// Get Chat.
  ///
  /// Получить чат.
  ///
  /// [chatId] - Идентификатор чата.
  @GET('/v2/chats/{chatId}')
  Future<ResultResponse<ChatDto>> getChat({@Path('chatId') required String chatId});

  /// Send Message.
  ///
  /// Отправить сообщение в чат.
  ///
  /// [chatId] - Идентификатор чата.
  ///
  /// [text] - Текст сообщения.
  ///
  /// [audio] - Голосовое сообщение.
  ///
  /// [isSearch] - Использовать поиск.
  ///
  /// [file] - Файл.
  @MultiPart()
  @POST('/v2/chats/{chatId}/message')
  Future<ResultResponse<ChatMessageDto>> sendMessage({
    @Path('chatId') required String chatId,
    @Part(name: 'text') String? text,
    @Part(name: 'isSearch') bool? isSearch = false,
    @Part(name: 'audio') File? audio,
    @Part(name: 'file') File? file,
  });
}
