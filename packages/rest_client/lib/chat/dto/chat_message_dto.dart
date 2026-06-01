// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/link_model_dto.dart';
import 'package:rest_client/chat/dto/message_type_dto.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable()
class ChatMessageDto {
  const ChatMessageDto({
    required this.id,
    required this.text,
    required this.type,
    required this.links,
    this.userMessageText,
    this.file,
  });

  factory ChatMessageDto.fromJson(Map<String, Object?> json) => _$ChatMessageDtoFromJson(json);

  /// Идентификатор сообщения
  final String id;

  /// Текст сообщения
  final String text;

  /// Тип сообщения
  final MessageTypeDto type;

  /// Список ссылок
  final List<LinkModelDto> links;

  /// Расшифрованное сообщение пользователя
  final String? userMessageText;

  /// Файл
  final String? file;

  Map<String, Object?> toJson() => _$ChatMessageDtoToJson(this);
}
