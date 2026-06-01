import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:rest_client/subscription/dto/promo_code_or_license_dto.dart';

class const PromoCodeOrLicense({
  required final String name,
  required final int? days,
  required final int? basePrice,
  required final String? discountType,
  required final int? discountValue,
  required final int? maxDiscountValue,
  required final int maxUses,
  required final List<Rate> rates,
  required final String type,
}) {
  factory decode(PromoCodeOrLicenseDto dto) => PromoCodeOrLicense(
    name: dto.name,
    days: dto.days,
    basePrice: dto.basePrice,
    discountType: dto.discountType,
    discountValue: dto.discountValue,
    maxDiscountValue: dto.maxDiscountValue,
    maxUses: dto.maxUses,
    rates: dto.rates.map(Rate.fromPromoCodeRate).toList(),
    type: dto.type,
  );
}

enum PromoCodeOrLicenseType(final String type) {
  promoCode('PROMO_CODE'),
  license('LICENSE'),
}
