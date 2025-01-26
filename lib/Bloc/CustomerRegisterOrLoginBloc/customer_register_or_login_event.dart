part of 'customer_register_or_login_bloc.dart';

@immutable
abstract class CustomerRegisterOrLoginEvent {}
class CustomerRegisterOrLoginRefreshEvent extends CustomerRegisterOrLoginEvent{
  String credentials;
  String country_code;
  String device_token;
  CustomerRegisterOrLoginRefreshEvent(this.credentials, this.country_code, this.device_token);
}
