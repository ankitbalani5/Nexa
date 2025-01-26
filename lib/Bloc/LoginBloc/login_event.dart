part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginRefreshEvent extends LoginEvent{
  String credentials;
  String password;
  String device_token;
  LoginRefreshEvent(this.credentials, this.password, this.device_token);
}
