// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat_v2/dto/assistant_type.dart';

part 'add_simple_chat_command.g.dart';

@JsonSerializable()
class AddSimpleChatCommand {
  const AddSimpleChatCommand({required this.assistantType, this.useContext = true, this.name});

  factory AddSimpleChatCommand.fromJson(Map<String, Object?> json) => _$AddSimpleChatCommandFromJson(json);

  /// Название чата
  final String? name;

  /// Использовать контекст чата
  final bool useContext;

  final AssistantType assistantType;

  Map<String, Object?> toJson() => _$AddSimpleChatCommandToJson(this);
}
