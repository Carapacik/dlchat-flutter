// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/chat_type_dto.dart';

part 'chat_model_dto.g.dart';

@JsonSerializable()
class ChatModelDto {
  const ChatModelDto({required this.id, required this.name, required this.description, required this.chatModelType});

  factory ChatModelDto.fromJson(Map<String, Object?> json) => _$ChatModelDtoFromJson(json);

  /// Идентификатор модели
  final String id;

  /// Название модели
  final String name;

  /// Описания модели
  final String? description;

  /// Тип модели
  final ChatTypeDto chatModelType;

  Map<String, Object?> toJson() => _$ChatModelDtoToJson(this);
}
