part of 'binding_cards_bloc.dart';

@Freezed(copyWith: false)
sealed class BindingCardsEvent with _$BindingCardsEvent {
  const factory start() = _BindingCardsStarted;

  const factory removeCard(String id) = _BindingCardsRemovedCard;
}
