// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum ChatTypeDto {
  @JsonValue('TEXT')
  text('TEXT'),
  @JsonValue('IMAGE')
  image('IMAGE'),
  @JsonValue('TEXT_TO_SPEECH')
  textToSpeech('TEXT_TO_SPEECH'),
  @JsonValue('SPEECH_TO_TEXT')
  speechToText('SPEECH_TO_TEXT'),
  @JsonValue('NUTRITION')
  nutrition('NUTRITION'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const ChatTypeDto(this.json);

  factory ChatTypeDto.fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;
}
