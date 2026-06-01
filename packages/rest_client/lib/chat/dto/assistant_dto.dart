// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'assistant_dto.g.dart';

@JsonSerializable()
class AssistantDto {
  const AssistantDto({
    required this.id,
    required this.name,
    required this.chatModelId,
    required this.presetId,
    this.description,
  });

  factory AssistantDto.fromJson(Map<String, Object?> json) => _$AssistantDtoFromJson(json);

  /// Идентификатор помощника
  final String id;

  /// Название помощника
  final String name;

  /// Идентификатор модели
  final String chatModelId;

  /// Идентификатор преднастройки
  final String presetId;

  /// Описание помощника
  final String? description;

  Map<String, Object?> toJson() => _$AssistantDtoToJson(this);
}
