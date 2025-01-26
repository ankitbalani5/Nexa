part of 'otp_verify_email_bloc.dart';

@immutable
sealed class OtpVerifyEmailState {}

final class OtpVerifyEmailInitial extends OtpVerifyEmailState {}
final class OtpVerifyEmailLoading extends OtpVerifyEmailState {}
final class OtpVerifyEmailSuccess extends OtpVerifyEmailState {
  EmailOtpVerifyModel emailOtpVerifyModel;
  OtpVerifyEmailSuccess(this.emailOtpVerifyModel);
}
final class OtpVerifyEmailError extends OtpVerifyEmailState {
  String error;
  OtpVerifyEmailError(this.error);
}
