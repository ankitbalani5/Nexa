part of 'all_shipping_address_bloc.dart';

@immutable
sealed class AllShippingAddressState {}

final class AllShippingAddressInitial extends AllShippingAddressState {}
final class AllShippingAddressLoading extends AllShippingAddressState {}
final class AllShippingAddressSuccess extends AllShippingAddressState {
  AllShippingAddressModel allShippingAddressModel;
  WareHouseModel wareHouseModel;
  AllShippingAddressSuccess(this.allShippingAddressModel, this.wareHouseModel);
}
final class AllShippingAddressError extends AllShippingAddressState {
  String error;
  AllShippingAddressError(this.error);
}
