// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'rate_dto.dart';

part 'rates_dto.g.dart';

@JsonSerializable()
class RatesDto {
  const RatesDto({required this.rates});

  factory RatesDto.fromJson(Map<String, Object?> json) => _$RatesDtoFromJson(json);

  /// Тарифы
  final List<RateDto> rates;

  Map<String, Object?> toJson() => _$RatesDtoToJson(this);
}
