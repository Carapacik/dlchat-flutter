import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/common/analytics/analytics.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/payment_method_data.dart';
import 'package:dlchat/src/feature/payment/model/payment_model.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_bloc.freezed.dart';
part 'payment_event.dart';
part 'payment_state.dart';

final class PaymentBloc({
  required final IPaymentRepository _paymentRepository,
  required final IUserRepository _userRepository,
  required final AnalyticsEventReporter _analytics,
}) extends Bloc<PaymentEvent, PaymentState> {
  this : super(const PaymentState.idle(paymentId: null)) {
    on<_PaymentPaid>(_pay);
    on<_PaymentUpdatePaymentStatus>(_updatePaymentStatus);
    on<_PaymentCancel>(_cancelPayment);
  }

  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _pay(_PaymentPaid event, Emitter<PaymentState> emitter) async {
    emitter(const PaymentState.processing(paymentId: null));
    await ExceptionHandler.handle(
      () async {
        final UserRate? userRate = event.userRate;
        final Rate selectedRate = event.selectedRate;
        late String paymentId;
        if (userRate == null) {
          unawaited(_analytics.logEvent(AnalyticsEvents.subscriptionStart));
          paymentId = await _paymentRepository.pay(
            paymentMethod: event.paymentMethod,
            rateId: selectedRate.id,
            email: event.email,
            specialOfferId: event.specialOfferId,
            promoCode: event.promoCode?.toUpperCase(),
          );
        } else if (selectedRate.rank == userRate.rank) {
          unawaited(_analytics.logEvent(AnalyticsEvents.subscriptionRenewal));
          paymentId = await _paymentRepository.prolong(
            paymentMethod: event.paymentMethod,
            rateId: selectedRate.id,
            email: event.email,
            specialOfferId: event.specialOfferId,
            promoCode: event.promoCode?.toUpperCase(),
          );
        } else if (selectedRate.rank > (userRate.rank ?? -1)) {
          unawaited(_analytics.logEvent(AnalyticsEvents.subscriptionStart));
          paymentId = await _paymentRepository.upgrade(
            paymentMethod: event.paymentMethod,
            rateId: selectedRate.id,
            email: event.email,
            specialOfferId: event.specialOfferId,
            promoCode: event.promoCode?.toUpperCase(),
          );
        } else {
          throw const AppException.unknown('Невозможно оплатить тариф ниже текущего');
        }
        final Payment payment = await _paymentRepository.getPayment(paymentId);
        if (event.email != null) {
          unawaited(_userRepository.saveEmail(event.email!));
        }
        emitter(PaymentState.successStart(payment, paymentId: paymentId));
        add(const PaymentEvent.updatePaymentStatus());
      },
      onError: (exception, stackTrace) async {
        // Если платеж уже существует
        if (exception.networkType == NetworkExceptionType.incompletePayment) {
          try {
            await _paymentRepository.cancelPayment();
            add(
              PaymentEvent.pay(
                event.selectedRate,
                event.userRate,
                event.paymentMethod,
                specialOfferId: event.specialOfferId,
                promoCode: event.promoCode,
                email: event.email,
              ),
            );
          } on Object {
            //
          }
          return;
        }
        emitter(PaymentState.failure(paymentId: state.paymentId, exception: exception));
      },
      onDone: () => emitter(PaymentState.idle(paymentId: state.paymentId)),
    );
  }

  Future<void> _updatePaymentStatus(_PaymentUpdatePaymentStatus event, Emitter<PaymentState> emitter) async {
    _startTimer(fromWebView: (state is PaymentProcessing) && (state as PaymentProcessing).fromWebView);
    if (state.paymentId == null) {
      return;
    }
    emitter(PaymentState.processing(paymentId: state.paymentId, fromWebView: event.fromWebView));
    await ExceptionHandler.handle(
      () async {
        final Payment payment = await _paymentRepository.getPayment(state.paymentId!);
        if (payment.status == PaymentStatus.succeeded) {
          _timer?.cancel();
          emitter(PaymentState.success(payment, paymentId: state.paymentId));
        } else {
          emitter(
            PaymentState.processing(
              paymentId: state.paymentId,
              fromWebView: (state is PaymentProcessing) && (state as PaymentProcessing).fromWebView,
            ),
          );
        }
      },
      onError: (exception, stackTrace) =>
          emitter(PaymentState.failure(paymentId: state.paymentId, exception: exception)),
    );
  }

  Future<void> _cancelPayment(_PaymentCancel event, Emitter<PaymentState> emitter) async {
    _timer?.cancel();
    await _paymentRepository.cancelPayment();
    emitter(const PaymentState.idle(paymentId: null));
  }

  void _startTimer({required bool fromWebView}) {
    // Отменяем предыдущий таймер, если он существует
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) => add(PaymentEvent.updatePaymentStatus(fromWebView: fromWebView)),
    );
  }
}
