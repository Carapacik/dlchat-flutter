// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/promo_code_rate_dto.dart';
import 'package:rest_client/subscription/dto/rate_dto.dart';

part 'promo_code_or_license_dto.g.dart';

@JsonSerializable()
class PromoCodeOrLicenseDto {
  const PromoCodeOrLicenseDto({
    required this.name,
    required this.days,
    required this.basePrice,
    required this.discountType,
    required this.discountValue,
    required this.maxDiscountValue,
    required this.maxUses,
    required this.rates,
    required this.type,
  });

  factory PromoCodeOrLicenseDto.fromJson(Map<String, Object?> json) => _$PromoCodeOrLicenseDtoFromJson(json);

  /// Название акции
  final String name;

  /// Дней акции
  final int? days;

  /// Сумма к оплате
  final int? basePrice;

  /// Тип скидки
  final String? discountType;

  /// Значение скидки
  final int? discountValue;

  /// Максимальный размер скидки
  final int? maxDiscountValue;

  /// Максимальное количество использований
  final int maxUses;

  /// Тарифы к промо коду
  final List<PromoCodeRateDto> rates;

  /// Тип промокода
  final String type;

  Map<String, Object?> toJson() => _$PromoCodeOrLicenseDtoToJson(this);
}
