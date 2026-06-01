import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/payment/model/binding_card.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'binding_cards_bloc.freezed.dart';
part 'binding_cards_event.dart';
part 'binding_cards_state.dart';

final class BindingCardsBloc({required final IPaymentRepository _paymentRepository})
    extends Bloc<BindingCardsEvent, BindingCardsState> {
  this : super(const BindingCardsState.processing([])) {
    on<BindingCardsEvent>(
      (event, emit) async => await switch (event) {
        final _BindingCardsStarted e => _start(e, emit),
        final _BindingCardsRemovedCard e => _removeCard(e, emit),
      },
    );
  }

  Future<void> _start(_BindingCardsStarted event, Emitter<BindingCardsState> emitter) async {
    emitter(BindingCardsState.processing(state.cards));
    await ExceptionHandler.handle(
      () async {
        final List<BindingCard> cards = await _paymentRepository.getBindingCards();
        emitter(BindingCardsState.success(cards));
      },
      onError: (exception, stackTrace) => emitter(BindingCardsState.failure(state.cards, exception: exception)),
      onDone: () => emitter(BindingCardsState.idle(state.cards)),
    );
  }

  Future<void> _removeCard(_BindingCardsRemovedCard event, Emitter<BindingCardsState> emitter) async {
    emitter(BindingCardsState.processing(state.cards));
    await ExceptionHandler.handle(
      () async {
        await _paymentRepository.deleteBingingCard(event.id);
        final List<BindingCard> newList = List.of(state.cards)..removeWhere((e) => e.id == event.id);
        emitter(BindingCardsState.success(newList, isCardRemoved: true));
      },
      onError: (exception, stackTrace) => emitter(BindingCardsState.failure(state.cards, exception: exception)),
      onDone: () => emitter(BindingCardsState.idle(state.cards)),
    );
  }
}
