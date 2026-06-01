import 'package:meta/meta.dart';
import 'package:rest_client/subscription/dto/special_offer_dto.dart';

@immutable
class const SpecialOffer({
  required final String id,
  required final String name,
  required final int days,
  required final int basePrice,
  required final int discountValue,
  required final int initialPrice,
}) {
  factory decode(SpecialOfferDto dto, int initialPrice) => SpecialOffer(
    id: dto.id,
    name: dto.name,
    days: dto.days,
    basePrice: dto.basePrice,
    discountValue: dto.discountValue,
    initialPrice: initialPrice,
  );

  String get period {
    switch (days) {
      case < 32:
        return '1 месяц';
      case >= 90 && <= 95:
        return '3 мес';
      case >= 180 && <= 182:
        return '6 мес';
      case >= 360 && <= 367:
        return '1 год';
      case _:
        return '$days дней';
    }
  }

  int get month {
    switch (days) {
      case < 32:
        return 1;
      case >= 90 && <= 95:
        return 3;
      case >= 180 && <= 182:
        return 6;
      case >= 360 && <= 367:
        return 12;
      case _:
        return days ~/ 30;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialOffer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          days == other.days &&
          basePrice == other.basePrice &&
          discountValue == other.discountValue &&
          initialPrice == other.initialPrice;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ days.hashCode ^ basePrice.hashCode ^ discountValue.hashCode ^ initialPrice.hashCode;
}
