// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/chat_dto.dart';

part 'chats_dto.g.dart';

@JsonSerializable()
class ChatsDto {
  const ChatsDto({required this.chats});

  factory ChatsDto.fromJson(Map<String, Object?> json) => _$ChatsDtoFromJson(json);

  /// Чаты
  final List<ChatDto> chats;

  Map<String, Object?> toJson() => _$ChatsDtoToJson(this);
}
