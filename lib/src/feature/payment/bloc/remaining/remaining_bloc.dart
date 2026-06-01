import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/remaining.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remaining_bloc.freezed.dart';
part 'remaining_event.dart';
part 'remaining_state.dart';

class RemainingBloc({required final IPaymentRepository _paymentRepository})
    extends Bloc<RemainingEvent, RemainingState> {
  this : super(const RemainingState.processing(null)) {
    on<RemainingEvent>(
      (event, emit) async => switch (event) {
        final _RemainingStarted e => _start(e, emit),
        final _RemainingTextDecreased e => _decreaseTextRemaining(e, emit),
        final _RemainingImageDecreased e => _decreaseImageRemaining(e, emit),
        final _RemainingTranscriptionDecreased e => _decreaseTranscriptionRemaining(e, emit),
      },
    );
  }

  Future<void> _start(_RemainingStarted event, Emitter<RemainingState> emitter) async {
    emitter(RemainingState.processing(state.remaining));
    await ExceptionHandler.handle(
      () async {
        final RemainingRequests remaining = await _paymentRepository.getUserRemaining();
        emitter(RemainingState.success(remaining));
      },
      onError: (exception, stackTrace) => emitter(RemainingState.failure(state.remaining, exception: exception)),
      onDone: () => emitter(RemainingState.idle(state.remaining)),
    );
  }

  void _decreaseTextRemaining(_RemainingTextDecreased event, Emitter<RemainingState> emitter) {
    emitter(
      RemainingState.idle(
        state.remaining?.requests == 0
            ? state.remaining
            : state.remaining?.copyWith(requests: state.remaining!.requests - 1),
        // : state.remaining?.copyWith(requests: state.remaining!.requests - event.symbols),
      ),
    );
  }

  void _decreaseImageRemaining(_RemainingImageDecreased event, Emitter<RemainingState> emitter) {
    emitter(
      RemainingState.idle(
        state.remaining?.images == 0 ? state.remaining : state.remaining?.copyWith(images: state.remaining!.images - 1),
      ),
    );
  }

  void _decreaseTranscriptionRemaining(_RemainingTranscriptionDecreased event, Emitter<RemainingState> emitter) {
    emitter(
      RemainingState.idle(
        state.remaining?.transcriptionSeconds == 0
            ? state.remaining
            : state.remaining?.copyWith(transcriptionSeconds: state.remaining!.transcriptionSeconds - 1),
      ),
    );
  }
}
