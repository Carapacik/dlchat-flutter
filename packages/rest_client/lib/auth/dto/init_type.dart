// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum InitType {
  @JsonValue('SMS')
  sms('SMS'),
  @JsonValue('TELEGRAM')
  telegram('TELEGRAM'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const InitType(this.json);

  factory InitType.fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;
}
