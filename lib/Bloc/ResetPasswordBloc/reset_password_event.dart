part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}
class ResetPasswordRefreshEvent extends ResetPasswordEvent {
  String credentials;
  String password;
  ResetPasswordRefreshEvent(this.credentials, this.password);
}
