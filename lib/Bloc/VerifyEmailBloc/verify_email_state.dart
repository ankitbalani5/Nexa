part of 'verify_email_bloc.dart';

@immutable
sealed class VerifyEmailState {}

final class VerifyEmailInitial extends VerifyEmailState {}

final class VerifyEmailLoading extends VerifyEmailState {}
final class VerifyEmailSuccess extends VerifyEmailState {
  VerifyEmailModel verifyEmailModel;
  VerifyEmailSuccess(this.verifyEmailModel);
}
final class VerifyEmailError extends VerifyEmailState {
  String error;
  VerifyEmailError(this.error);
}