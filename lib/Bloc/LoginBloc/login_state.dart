part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  LoginModel loginModel;
  LoginSuccess(this.loginModel);
}
final class LoginError extends LoginState {
  String error;
  LoginError(this.error);
}
