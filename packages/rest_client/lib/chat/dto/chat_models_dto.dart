// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/chat_model_dto.dart';

part 'chat_models_dto.g.dart';

@JsonSerializable()
class ChatModelsDto {
  const ChatModelsDto({required this.models});

  factory ChatModelsDto.fromJson(Map<String, Object?> json) => _$ChatModelsDtoFromJson(json);

  /// Список моделей
  final List<ChatModelDto> models;

  Map<String, Object?> toJson() => _$ChatModelsDtoToJson(this);
}
