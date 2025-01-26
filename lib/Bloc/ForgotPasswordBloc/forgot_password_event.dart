part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}
class ForgotPasswordRefreshEvent extends ForgotPasswordEvent {
  String credentials;
  ForgotPasswordRefreshEvent(this.credentials);
}
