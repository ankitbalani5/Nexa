part of 'add_shipping_address_bloc.dart';

@immutable
sealed class AddShippingAddressState {}

final class AddShippingAddressInitial extends AddShippingAddressState {}
final class AddShippingAddressLoading extends AddShippingAddressState {}
final class AddShippingAddressSuccess extends AddShippingAddressState {
  AddShippingAddressModel addShippingAddressModel;
  AddShippingAddressSuccess(this.addShippingAddressModel);
}
final class AddShippingAddressError extends AddShippingAddressState {
  String error;
  AddShippingAddressError(this.error);
}
