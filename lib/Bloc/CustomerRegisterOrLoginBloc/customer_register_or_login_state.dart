part of 'customer_register_or_login_bloc.dart';

@immutable
abstract class CustomerRegisterOrLoginState {}

class CustomerRegisterOrLoginInitial extends CustomerRegisterOrLoginState {}
class CustomerRegisterOrLoginLoading extends CustomerRegisterOrLoginState {}
class CustomerRegisterOrLoginSuccess extends CustomerRegisterOrLoginState {
  CustomerRegisterOrLoginModel customerRegisterOrLoginModel;
  CustomerRegisterOrLoginSuccess(this.customerRegisterOrLoginModel);
}
class CustomerRegisterOrLoginError extends CustomerRegisterOrLoginState {
  String error;
  CustomerRegisterOrLoginError(this.error);
}
