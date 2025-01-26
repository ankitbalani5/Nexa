part of 'customer_existing_bloc.dart';

@immutable
abstract class CustomerExistingEvent {}

class CustomerExistingRefreshEvent extends CustomerExistingEvent {
  String credentials;
  String country_code;
  CustomerExistingRefreshEvent(this.credentials, this.country_code);
}
