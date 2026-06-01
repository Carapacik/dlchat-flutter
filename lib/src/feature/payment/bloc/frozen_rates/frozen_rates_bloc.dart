import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'frozen_rates_bloc.freezed.dart';
part 'frozen_rates_event.dart';
part 'frozen_rates_state.dart';

final class FrozenRatesBloc({required final IPaymentRepository _paymentRepository})
    extends Bloc<FrozenRatesEvent, FrozenRatesState> {
  this : super(const FrozenRatesState.processing([])) {
    on<_FrozenRatesStarted>(_start);
  }

  Future<void> _start(_FrozenRatesStarted event, Emitter<FrozenRatesState> emitter) async {
    emitter(FrozenRatesState.processing(state.rates));
    await ExceptionHandler.handle(
      () async {
        final List<UserRate> rates = await _paymentRepository.getFrozenSubscriptions();
        emitter(FrozenRatesState.success(rates));
      },
      onError: (exception, stackTrace) => emitter(FrozenRatesState.failure(state.rates, exception: exception)),
      onDone: () => emitter(FrozenRatesState.idle(state.rates)),
    );
  }
}
