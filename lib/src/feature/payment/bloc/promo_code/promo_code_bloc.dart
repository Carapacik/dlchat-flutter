import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/promo_code.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'promo_code_bloc.freezed.dart';
part 'promo_code_event.dart';
part 'promo_code_state.dart';

final class PromoCodeBloc({required final IPaymentRepository _paymentRepository})
    extends Bloc<PromoCodeEvent, PromoCodeState> {
  this : super(const PromoCodeState.idle(null, null)) {
    on<_PromoCodeLicenseActivated>(_licenseActivate);
    on<_PromoCodeVerified>(_verifyPromo);
    on<_PromoCodePromoCleared>(_clear);
  }

  Future<void> _licenseActivate(_PromoCodeLicenseActivated event, Emitter<PromoCodeState> emitter) async {
    emitter(PromoCodeState.processing(state.promoCodeOrLicense, state.code));
    await ExceptionHandler.handle(
      () async {
        if (state.code != null) {
          await _paymentRepository.activateLicense(state.code!);
          emitter(PromoCodeState.successLicenseActivated(state.promoCodeOrLicense, state.code));
        }
      },
      onError: (exception, stackTrace) =>
          emitter(PromoCodeState.failure(state.promoCodeOrLicense, state.code, exception: exception)),
      onDone: () => emitter(PromoCodeState.idle(state.promoCodeOrLicense, state.code)),
    );
  }

  Future<void> _verifyPromo(_PromoCodeVerified event, Emitter<PromoCodeState> emitter) async {
    emitter(PromoCodeState.processing(state.promoCodeOrLicense, state.code));
    await ExceptionHandler.handle(
      () async {
        final PromoCodeOrLicense promoCode = await _paymentRepository.verifyPromoCode(event.code);
        emitter(PromoCodeState.success(promoCode, event.code));
      },
      onError: (exception, stackTrace) =>
          emitter(PromoCodeState.failure(state.promoCodeOrLicense, state.code, exception: exception)),
      onDone: () => emitter(PromoCodeState.idle(state.promoCodeOrLicense, state.code)),
    );
  }

  void _clear(_PromoCodePromoCleared event, Emitter<PromoCodeState> emitter) {
    emitter(const PromoCodeState.idle(null, null));
  }
}
