part of 'all_shipping_address_bloc.dart';

@immutable
sealed class AllShippingAddressEvent {}
class FetchShippingAddressEvent extends AllShippingAddressEvent {}
class DeleteShippingAddressEvent extends AllShippingAddressEvent {
  dynamic item;
  DeleteShippingAddressEvent(this.item);
}

class ClearShippingAddressEvent extends AllShippingAddressEvent{}
