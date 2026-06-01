import 'package:meta/meta.dart';
import 'package:rest_client/subscription/dto/user_subscription_dto.dart';

@immutable
class const UserRate({
  required final String id,
  required final String name,
  required final int? rank,
  required final String color,
  required final int numberOfRequests,
  required final int numberOfImages,
  required final int transcriptionSeconds,
  required final String status,
  required final bool autoCharge,
  final DateTime? expiredAt,
  final DateTime? frozenAt,
}) {
  factory decode(UserSubscriptionDto dto) => UserRate(
    id: dto.id,
    name: dto.name,
    color: dto.color,
    rank: dto.rank,
    numberOfRequests: dto.numberOfRequests,
    numberOfImages: dto.numberOfImages,
    transcriptionSeconds: dto.transcriptionSeconds,
    status: dto.status,
    autoCharge: dto.autocharge,
    expiredAt: dto.expiredAt,
    frozenAt: dto.frozenAt,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          color == other.color &&
          rank == other.rank &&
          numberOfRequests == other.numberOfRequests &&
          numberOfImages == other.numberOfImages &&
          numberOfImages == other.transcriptionSeconds &&
          status == other.status &&
          autoCharge == other.autoCharge &&
          expiredAt == other.expiredAt &&
          frozenAt == other.frozenAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      color.hashCode ^
      rank.hashCode ^
      numberOfRequests.hashCode ^
      numberOfImages.hashCode ^
      transcriptionSeconds.hashCode ^
      status.hashCode ^
      autoCharge.hashCode ^
      expiredAt.hashCode ^
      frozenAt.hashCode;
}
