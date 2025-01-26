part of 'country_bloc.dart';

@immutable
sealed class CountryEvent {}

class CountryRefreshEvent extends CountryEvent {}

class AddShippingAddEvent extends CountryEvent{
  String address_id;
  String name;
  String address;
  String country;
  String state;
  String city;
  String zip_code;
  String country_code;
  String phone;
  String primary_address;
  BuildContext context;
  AddShippingAddEvent(this.address_id, this.name, this.address,
    this.country, this.state, this.city, this.zip_code, this.country_code,
    this.phone, this.primary_address, this.context);
}
