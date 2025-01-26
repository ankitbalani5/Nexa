part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}
final class ResetPasswordLoading extends ResetPasswordState {}
final class ResetPasswordSuccess extends ResetPasswordState {
  String message;
  ResetPasswordSuccess(this.message);
}
final class ResetPasswordError extends ResetPasswordState {
  String error;
  ResetPasswordError(this.error);
}
