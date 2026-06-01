import 'package:json_annotation/json_annotation.dart';

part 'transcription_dto.g.dart';

@JsonSerializable()
class const TranscriptionDto({
  /// Идентификатор транскрипции
  required final String id,

  /// Название транскрипции
  required final String name,

  /// Статус транскрипции
  required final String status,

  /// Дата создания
  required final DateTime createdAt,

  /// Содержимое транскрипции
  final String? content,
}) {
  factory fromJson(Map<String, Object?> json) => _$TranscriptionDtoFromJson(json);

  Map<String, Object?> toJson() => _$TranscriptionDtoToJson(this);
}

@JsonSerializable()
class const TranscriptionListDto({required final List<TranscriptionDto> transcriptions}) {
  factory fromJson(Map<String, Object?> json) => _$TranscriptionListDtoFromJson(json);

  Map<String, Object?> toJson() => _$TranscriptionListDtoToJson(this);
}
