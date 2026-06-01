part of 'otp_code_bloc.dart';

@Freezed(copyWith: false)
sealed class OtpCodeEvent with _$OtpCodeEvent {
  const factory verifyPressed(String code, String screenResolution) = _OtpCodeVerifyPressed;

  const factory resend() = _OtpCodeResent;
}
