part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}
class ForgotPasswordLoading extends ForgotPasswordState {}
class ForgotPasswordSuccess extends ForgotPasswordState {
  ForgotPasswordModel forgotPasswordModel;
  ForgotPasswordSuccess(this.forgotPasswordModel);
}
class ForgotPasswordError extends ForgotPasswordState {
  String error;
  ForgotPasswordError(this.error);
}
