import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rates_bloc.freezed.dart';
part 'rates_event.dart';
part 'rates_state.dart';

final class RatesBloc({required final IPaymentRepository _paymentRepository}) extends Bloc<RatesEvent, RatesState> {
  this : super(const RatesState.processing([])) {
    on<_RatesStarted>(_start);
  }

  Future<void> _start(_RatesStarted event, Emitter<RatesState> emitter) async {
    emitter(RatesState.processing(state.rates));
    await ExceptionHandler.handle(
      () async {
        final List<Rate> rates = await _paymentRepository.getRates();
        emitter(RatesState.success(rates));
      },
      onError: (exception, stackTrace) => emitter(RatesState.failure(state.rates, exception: exception)),
      onDone: () => emitter(RatesState.idle(state.rates)),
    );
  }
}
