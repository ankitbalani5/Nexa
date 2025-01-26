part of 'otp_verify_forgot_password_bloc.dart';

@immutable
sealed class OtpVerifyForgotPasswordEvent {}
class OtpVerifyForgotPasswordRefreshEvent extends OtpVerifyForgotPasswordEvent {
  String credentials;
  String otp;
  OtpVerifyForgotPasswordRefreshEvent(this.credentials, this.otp);
}
