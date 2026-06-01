import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/transcriptions/dto/message_dto.dart';
import 'package:rest_client/transcriptions/dto/transcription_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'transcriptions_client.g.dart';

@RestApi()
abstract class TranscriptionsClient {
  factory(Dio dio, {String? baseUrl}) = _TranscriptionsClient;

  /// Get Transcriptions.
  ///
  /// Получить транскрипции.
  ///
  /// [limit] - Лимит.
  ///
  /// [offset] - Оффсет.
  @GET('/v1/transcriptions/')
  Future<ResultResponse<TranscriptionListDto>> getTranscriptions({
    @Query('limit') int limit = 30,
    @Query('offset') int offset = 0,
  });

  /// Create Transcription.
  ///
  /// Создать транскрипцию.
  ///
  /// [audio] - Файл.
  @MultiPart()
  @POST('/v1/transcriptions/')
  Future<void> createTranscription({
    @Part(name: 'audio') File? audio,
    @Part(name: 'url') String? url,
    @SendProgress() ProgressCallback? onSendProgress,
  });

  /// Get Transcription.
  ///
  /// Получить транскрипцию.
  ///
  /// [transcriptionId] - Идентификатор транскрипции.
  @GET('/v1/transcriptions/{transcriptionId}')
  Future<ResultResponse<TranscriptionDto>> getTranscriptionById({
    @Path('transcriptionId') required String transcriptionId,
  });

  /// Get Transcription Messages.
  ///
  /// Получить сообщения транскрипции.
  ///
  /// [transcriptionId] - Идентификатор чата.
  ///
  /// [limit] - Лимит.
  ///
  /// [offset] - Оффсет.
  @GET('/v1/transcriptions/{transcriptionId}/messages')
  Future<ResultResponse<MessageListDto>> getTranscriptionMessages({
    @Path('transcriptionId') required String transcriptionId,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });
}
