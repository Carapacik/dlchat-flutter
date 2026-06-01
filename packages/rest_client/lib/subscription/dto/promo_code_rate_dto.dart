// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'promo_code_rate_dto.g.dart';

@JsonSerializable()
class PromoCodeRateDto {
  const PromoCodeRateDto({
    required this.id,
    required this.rank,
    required this.name,
    required this.numberOfRequests,
    required this.numberOfImages,
    required this.transcriptionSeconds,
    required this.initialPrice,
    required this.salePrice,
  });

  factory PromoCodeRateDto.fromJson(Map<String, Object?> json) => _$PromoCodeRateDtoFromJson(json);

  /// Идентификатор тарифа
  final String id;

  /// Уровень тарифа
  final int rank;

  /// Наименование тарифа
  final String name;

  /// Лимит по сообщениям
  final int numberOfRequests;

  /// Лимит по изображениям
  final int numberOfImages;

  /// Лимит по транскрибации
  final int transcriptionSeconds;

  /// Стоимость в месяц
  final int initialPrice;

  /// Цена с промокодом
  final int salePrice;

  Map<String, Object?> toJson() => _$PromoCodeRateDtoToJson(this);
}
