part of 'authentication_bloc.dart';

@Freezed(copyWith: false)
sealed class AuthenticationEvent with _$AuthenticationEvent {
  const factory userListen(User user) = _AuthenticationUserListen;

  const factory signOutPressed() = _AuthenticationSignOutPressed;
}
