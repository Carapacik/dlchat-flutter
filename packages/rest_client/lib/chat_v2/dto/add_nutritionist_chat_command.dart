// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/chat_v2/dto/assistant_type.dart';

part 'add_nutritionist_chat_command.g.dart';

@JsonSerializable()
class AddNutritionistChatCommand {
  const AddNutritionistChatCommand({
    required this.assistantType,
    required this.initialMessage,
    this.useContext = true,
    this.name,
  });

  factory AddNutritionistChatCommand.fromJson(Map<String, Object?> json) => _$AddNutritionistChatCommandFromJson(json);

  /// Название чата
  final String? name;

  /// Использовать контекст чата
  final bool useContext;

  /// Сообщение инициации помощника
  final String initialMessage;

  final AssistantType assistantType;

  Map<String, Object?> toJson() => _$AddNutritionistChatCommandToJson(this);
}
