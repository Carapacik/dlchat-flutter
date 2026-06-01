part of 'promo_code_bloc.dart';

@Freezed(copyWith: false)
sealed class PromoCodeEvent with _$PromoCodeEvent {
  const factory licenseActivate() = _PromoCodeLicenseActivated;

  const factory verifyPromo(String code) = _PromoCodeVerified;

  const factory clear() = _PromoCodePromoCleared;
}
