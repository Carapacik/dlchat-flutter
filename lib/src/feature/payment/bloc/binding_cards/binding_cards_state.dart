part of 'binding_cards_bloc.dart';

@Freezed()
sealed class const BindingCardsState._() with _$BindingCardsState {
  const factory idle(List<BindingCard> cards) = BindingCardsIdle;

  const factory processing(List<BindingCard> cards) = BindingCardsProcessing;

  const factory success(List<BindingCard> cards, {@Default(false) bool isCardRemoved}) = BindingCardsSuccess;

  const factory failure(List<BindingCard> cards, {required AppException exception}) = BindingCardsFailure;

  bool get inProgress => this is BindingCardsProcessing;
}
