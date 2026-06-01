// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat/dto/assistant_dto.dart';

part 'assistants_dto.g.dart';

@JsonSerializable()
class AssistantsDto {
  const AssistantsDto({required this.assistants});

  factory AssistantsDto.fromJson(Map<String, Object?> json) => _$AssistantsDtoFromJson(json);

  /// Список помощников
  final List<AssistantDto> assistants;

  Map<String, Object?> toJson() => _$AssistantsDtoToJson(this);
}
