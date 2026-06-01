// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_subscription_dto.g.dart';

@JsonSerializable()
class UserSubscriptionDto {
  const UserSubscriptionDto({
    required this.id,
    required this.color,
    required this.rank,
    required this.name,
    required this.status,
    required this.autocharge,
    this.numberOfRequests = 1,
    this.numberOfImages = 1,
    this.transcriptionSeconds = 0,
    this.expiredAt,
    this.frozenAt,
  });

  factory UserSubscriptionDto.fromJson(Map<String, Object?> json) => _$UserSubscriptionDtoFromJson(json);

  /// Идентификатор тарифа пользователя
  final String id;

  /// Цвет тарифа
  final String color;

  /// Уровень тарифа
  final int? rank;

  /// Наименование тарифа
  final String name;

  /// Лимит по сообщениям
  final int numberOfRequests;

  /// Лимит по изображениям
  final int numberOfImages;

  /// Лимит по транскрибации
  final int transcriptionSeconds;

  /// Истекает
  final DateTime? expiredAt;

  /// Статус подписки
  final String status;

  /// Статус подписки
  final bool autocharge;

  final DateTime? frozenAt;

  Map<String, Object?> toJson() => _$UserSubscriptionDtoToJson(this);
}
