// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum MessageTypeV2Dto {
  @JsonValue('USER')
  user('USER'),
  @JsonValue('ASSISTANT')
  assistant('ASSISTANT'),
  @JsonValue('IMAGE_ASSISTANT')
  imageAssistant('IMAGE_ASSISTANT'),
  @JsonValue('IMAGE')
  image('IMAGE'),
  @JsonValue('TELEGRAM_ASSISTANT')
  telegramAssistant('TELEGRAM_ASSISTANT'),
  @JsonValue('TELEGRAM')
  telegram('TELEGRAM'),
  @JsonValue('TRANSCRIPTION')
  transcription('TRANSCRIPTION'),
  @JsonValue('TRANSCRIPTION_ASSISTANT')
  transcriptionAssistant('TRANSCRIPTION_ASSISTANT'),
  @JsonValue('NUTRITION')
  nutrition('NUTRITION'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const MessageTypeV2Dto(this.json);

  factory MessageTypeV2Dto.fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;
}
