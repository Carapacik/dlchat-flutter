// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/message_type_dto.dart';

part 'send_chat_message_command.g.dart';

@JsonSerializable()
class SendChatMessageCommand {
  const SendChatMessageCommand({required this.text, required this.isSearch});

  factory SendChatMessageCommand.fromJson(Map<String, Object?> json) => _$SendChatMessageCommandFromJson(json);

  /// Текст сообщения
  final String text;

  /// Использовать поиск
  final bool isSearch;

  Map<String, Object?> toJson() => _$SendChatMessageCommandToJson(this);
}
