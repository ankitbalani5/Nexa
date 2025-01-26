part of 'otp_verify_forgot_password_bloc.dart';

@immutable
sealed class OtpVerifyForgotPasswordState {}

final class OtpVerifyForgotPasswordInitial extends OtpVerifyForgotPasswordState {}
final class OtpVerifyForgotPasswordLoading extends OtpVerifyForgotPasswordState {}
final class OtpVerifyForgotPasswordSuccess extends OtpVerifyForgotPasswordState {
  OtpVerifyModel otpVerifyModel;
  OtpVerifyForgotPasswordSuccess(this.otpVerifyModel);
}
final class OtpVerifyForgotPasswordError extends OtpVerifyForgotPasswordState {
  String error;
  OtpVerifyForgotPasswordError(this.error);
}
