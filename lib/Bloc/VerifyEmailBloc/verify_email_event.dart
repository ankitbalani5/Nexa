part of 'verify_email_bloc.dart';

@immutable
sealed class VerifyEmailEvent {}
class VerifyEmailNewEvent extends VerifyEmailEvent {
  String credentials;
  VerifyEmailNewEvent(this.credentials);
}