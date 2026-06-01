import 'package:dlchat/src/feature/payment/model/special_offer.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/subscription/dto/promo_code_rate_dto.dart';
import 'package:rest_client/subscription/dto/rate_dto.dart';

@immutable
class const Rate({
  required final String id,
  required final String color,
  required final int rank,
  required final String name,
  required final int numberOfRequests,
  required final int numberOfImages,
  required final int transcriptionSeconds,
  required final int initialPrice,
  required final List<SpecialOffer> specialOffers,
  final int salePrice = 0,
}) {
  factory decode(RateDto dto) => Rate(
    id: dto.id,
    color: dto.color,
    rank: dto.rank,
    name: dto.name,
    numberOfRequests: dto.numberOfRequests,
    numberOfImages: dto.numberOfImages,
    transcriptionSeconds: dto.transcriptionSeconds,
    initialPrice: dto.initialPrice,
    specialOffers: dto.specialOffers.map((e) => SpecialOffer.decode(e, dto.initialPrice)).toList(),
  );

  factory fromUserRate(UserRate userRate) => Rate(
    id: userRate.id,
    name: userRate.name,
    color: userRate.color,
    rank: 0,
    numberOfRequests: userRate.numberOfRequests,
    numberOfImages: userRate.numberOfImages,
    transcriptionSeconds: userRate.transcriptionSeconds,
    initialPrice: 0,
    specialOffers: const [],
  );

  factory fromPromoCodeRate(PromoCodeRateDto promoCodeRate) => Rate(
    id: promoCodeRate.id,
    name: promoCodeRate.name,
    color: '',
    rank: promoCodeRate.rank,
    numberOfRequests: promoCodeRate.numberOfRequests,
    numberOfImages: promoCodeRate.numberOfImages,
    transcriptionSeconds: promoCodeRate.transcriptionSeconds,
    initialPrice: promoCodeRate.initialPrice,
    salePrice: promoCodeRate.salePrice,
    specialOffers: const [],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Rate && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
