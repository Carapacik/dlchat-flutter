// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum RatesKey {
  @JsonValue('STANDARD')
  standard('STANDARD'),
  @JsonValue('BUSINESS')
  business('BUSINESS'),
  @JsonValue('PREMIUM')
  premium('PREMIUM'),
  @JsonValue('ELITE')
  elite('ELITE'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const RatesKey(this.json);

  factory RatesKey.fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);

  final String? json;
}
