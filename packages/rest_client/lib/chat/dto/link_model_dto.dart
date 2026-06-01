// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'link_model_dto.g.dart';

@JsonSerializable()
class LinkModelDto {
  const LinkModelDto({required this.id, required this.title, required this.url});

  factory LinkModelDto.fromJson(Map<String, Object?> json) => _$LinkModelDtoFromJson(json);

  /// Идентификатор ссылки
  final String id;

  /// Заголовок ссылки
  final String title;

  /// Ссылка
  final String url;

  Map<String, Object?> toJson() => _$LinkModelDtoToJson(this);
}
