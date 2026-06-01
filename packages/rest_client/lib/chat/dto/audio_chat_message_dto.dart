// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/link_model_dto.dart';
import 'package:rest_client/chat/dto/message_type_dto.dart';

part 'audio_chat_message_dto.g.dart';

@JsonSerializable()
class AudioChatMessageDto {
  const AudioChatMessageDto({
    required this.id,
    required this.userMessageText,
    required this.text,
    required this.type,
    required this.links,
  });

  factory AudioChatMessageDto.fromJson(Map<String, Object?> json) => _$AudioChatMessageDtoFromJson(json);

  /// Идентификатор сообщения
  final String id;

  /// Расшифрованное сообщение пользователя
  final String userMessageText;

  /// Текст сообщения
  final String text;

  /// Тип сообщения
  final MessageTypeDto type;

  /// Список ссылок
  final List<LinkModelDto> links;

  Map<String, Object?> toJson() => _$AudioChatMessageDtoToJson(this);
}
