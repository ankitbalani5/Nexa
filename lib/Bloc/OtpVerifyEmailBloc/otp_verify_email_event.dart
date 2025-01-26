part of 'otp_verify_email_bloc.dart';

@immutable
sealed class OtpVerifyEmailEvent {}

class OtpVerifyNewEvent extends OtpVerifyEmailEvent {
  String credentials;
  String otp;
  OtpVerifyNewEvent(this.credentials, this.otp);
}