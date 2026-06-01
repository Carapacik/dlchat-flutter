import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_rate_bloc.freezed.dart';
part 'user_rate_event.dart';
part 'user_rate_state.dart';

final class UserRateBloc({required final IPaymentRepository _paymentRepository})
    extends Bloc<UserRateEvent, UserRateState> {
  this : super(const UserRateState.processing(null)) {
    on<_UserRateStarted>(_start);
    on<_UserRateUpdated>(_update);
  }

  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _start(_UserRateStarted event, Emitter<UserRateState> emitter) async {
    emitter(const UserRateState.processing(null));
    await ExceptionHandler.handle(
      () async {
        final UserRate userRate = await _paymentRepository.getCurrentSubscription();
        emitter(UserRateState.success(userRate));
      },
      onError: (exception, stackTrace) => emitter(UserRateState.failure(state.userRate, exception: exception)),
      onDone: () => emitter(UserRateState.idle(state.userRate)),
    );
  }

  Future<void> _update(_UserRateUpdated event, Emitter<UserRateState> emitter) async {
    _timer?.cancel();
    await ExceptionHandler.handle(
      () async {
        final UserRate newUserRate = await _paymentRepository.getCurrentSubscription();
        if (newUserRate == state.userRate) {
          _startTimer();
          return;
        }
        emitter(UserRateState.idle(newUserRate));
        if (newUserRate.status == 'PAYING') {
          _startTimer();
        } else if (newUserRate.status == 'ACTIVE') {
          emitter(UserRateState.success(newUserRate));
        }
      },
      onError: (exception, stackTrace) => emitter(UserRateState.failure(state.userRate, exception: exception)),
      onDone: () => emitter(UserRateState.idle(state.userRate)),
    );
  }

  void _startTimer() {
    // Отменяем предыдущий таймер, если он существует
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) => add(const UserRateEvent.update()));
  }
}
