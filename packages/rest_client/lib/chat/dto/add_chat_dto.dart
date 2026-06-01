// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'add_chat_dto.g.dart';

@JsonSerializable()
class AddChatDto {
  const AddChatDto({required this.id, required this.name, required this.type, this.preset});

  factory AddChatDto.fromJson(Map<String, Object?> json) => _$AddChatDtoFromJson(json);

  /// Идентификатор чата
  final String id;

  /// Название чата
  final String name;

  /// Тип чата
  final String type;

  /// Настройка чата
  final String? preset;

  Map<String, Object?> toJson() => _$AddChatDtoToJson(this);
}
