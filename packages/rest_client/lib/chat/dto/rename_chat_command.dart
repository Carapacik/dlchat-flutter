// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'rename_chat_command.g.dart';

@JsonSerializable()
class RenameChatCommand {
  const RenameChatCommand({required this.name});

  factory RenameChatCommand.fromJson(Map<String, Object?> json) => _$RenameChatCommandFromJson(json);

  /// Название чата
  final String name;

  Map<String, Object?> toJson() => _$RenameChatCommandToJson(this);
}
