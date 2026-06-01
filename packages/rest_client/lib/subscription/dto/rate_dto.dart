// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'special_offer_dto.dart';

part 'rate_dto.g.dart';

@JsonSerializable()
class RateDto {
  const RateDto({
    required this.id,
    required this.color,
    required this.rank,
    required this.name,
    required this.numberOfRequests,
    required this.numberOfImages,
    required this.transcriptionSeconds,
    required this.initialPrice,
    required this.specialOffers,
  });

  factory RateDto.fromJson(Map<String, Object?> json) => _$RateDtoFromJson(json);

  /// Идентификатор тарифа
  final String id;

  /// Цвет тарифа
  final String color;

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

  /// Спец. предложения
  final List<SpecialOfferDto> specialOffers;

  Map<String, Object?> toJson() => _$RateDtoToJson(this);
}
