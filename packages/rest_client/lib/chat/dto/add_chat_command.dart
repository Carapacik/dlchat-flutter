// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'add_chat_command.g.dart';

@JsonSerializable()
class AddChatCommand {
  const AddChatCommand({required this.chatModelId, this.name, this.presetId, this.useContext});

  factory AddChatCommand.fromJson(Map<String, Object?> json) => _$AddChatCommandFromJson(json);

  /// Идентификатор модели
  final String chatModelId;

  /// Имя чата
  final String? name;

  /// Настройка чата
  final String? presetId;

  /// Использовать контекст чата
  final bool? useContext;

  Map<String, Object?> toJson() => _$AddChatCommandToJson(this);
}
