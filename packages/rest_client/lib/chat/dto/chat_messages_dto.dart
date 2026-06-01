// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/chat_message_dto.dart';

part 'chat_messages_dto.g.dart';

@JsonSerializable()
class ChatMessagesDto {
  const ChatMessagesDto({required this.messages});

  factory ChatMessagesDto.fromJson(Map<String, Object?> json) => _$ChatMessagesDtoFromJson(json);

  /// Сообщения чата
  final List<ChatMessageDto> messages;

  Map<String, Object?> toJson() => _$ChatMessagesDtoToJson(this);
}
