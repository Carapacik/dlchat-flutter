// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'special_offer_dto.g.dart';

@JsonSerializable()
class SpecialOfferDto {
  const SpecialOfferDto({
    required this.id,
    required this.name,
    required this.days,
    required this.basePrice,
    required this.discountValue,
  });

  factory SpecialOfferDto.fromJson(Map<String, Object?> json) => _$SpecialOfferDtoFromJson(json);

  /// Идентификатор спец. предложения
  final String id;

  /// Наименование спец. предложения
  final String name;

  /// Месяцы
  final int days;

  /// Стоимость с учетом скидки
  final int basePrice;

  /// Величина скидки
  final int discountValue;

  Map<String, Object?> toJson() => _$SpecialOfferDtoToJson(this);
}
