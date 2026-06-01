part of 'promo_code_bloc.dart';

@Freezed()
sealed class const PromoCodeState._() with _$PromoCodeState {
  const factory idle(PromoCodeOrLicense? promoCodeOrLicense, String? code) = PromoCodeIdle;

  const factory processing(PromoCodeOrLicense? promoCodeOrLicense, String? code) = PromoCodeProcessing;

  const factory success(PromoCodeOrLicense? promoCodeOrLicense, String? code) = PromoCodeSuccess;

  const factory successLicenseActivated(PromoCodeOrLicense? promoCodeOrLicense, String? code) =
      PromoCodeSuccessLicenseActivated;

  const factory failure(PromoCodeOrLicense? promoCodeOrLicense, String? code, {required AppException exception}) =
      PromoCodeFailure;
}
