// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/user_subscription_dto.dart';

part 'user_subscriptions_dto.g.dart';

@JsonSerializable()
class UserSubscriptionsDto {
  const UserSubscriptionsDto({required this.subscriptions});

  factory UserSubscriptionsDto.fromJson(Map<String, Object?> json) => _$UserSubscriptionsDtoFromJson(json);

  final List<UserSubscriptionDto> subscriptions;

  Map<String, Object?> toJson() => _$UserSubscriptionsDtoToJson(this);
}
