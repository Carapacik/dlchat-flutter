// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum PaymentStateDto {
  @JsonValue('CREATED')
  created('CREATED'),
  @JsonValue('IN_PROGRESS')
  inProgress('IN_PROGRESS'),
  @JsonValue('SUCCEEDED')
  succeeded('SUCCEEDED'),
  @JsonValue('FAILED')
  failed('FAILED'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const PaymentStateDto(this.json);

  factory PaymentStateDto.fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;
}
