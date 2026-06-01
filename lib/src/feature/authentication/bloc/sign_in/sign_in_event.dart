part of 'sign_in_bloc.dart';

@Freezed(copyWith: false)
sealed class SignInEvent with _$SignInEvent {
  const factory sendPhone(String phone, SignInType type) = _SignInPhoneSent;
}
