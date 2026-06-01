// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'pay_rate_response.g.dart';

@JsonSerializable()
class PayRateResponse {
  const PayRateResponse({required this.id});

  factory PayRateResponse.fromJson(Map<String, Object?> json) => _$PayRateResponseFromJson(json);

  /// Идентификатор платежа
  final String id;

  Map<String, Object?> toJson() => _$PayRateResponseToJson(this);
}
