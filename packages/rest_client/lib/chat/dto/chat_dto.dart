// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/chat_model_dto.dart';
import 'package:rest_client/chat/dto/chat_type_dto.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
class ChatDto {
  const ChatDto({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.useContext,
    this.presetId,
  });

  factory ChatDto.fromJson(Map<String, Object?> json) => _$ChatDtoFromJson(json);

  /// Идентификатор чата
  final String id;

  /// Название чата
  final String name;

  /// Натсройки чата
  final String? presetId;

  /// Тип чата
  final ChatTypeDto type;

  /// Статус чата
  final String status;

  /// Использовать контекст чата
  final bool useContext;

  Map<String, Object?> toJson() => _$ChatDtoToJson(this);
}
