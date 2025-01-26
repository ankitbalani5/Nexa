part of 'cart_products_bloc.dart';

@immutable
abstract class CartProductsEvent {}
class CartProductsRefreshEvent extends CartProductsEvent {
  final String address_id;
  CartProductsRefreshEvent(this.address_id);
}

class IncreaseCartEvent extends CartProductsEvent {
  final dynamic item;
  IncreaseCartEvent(this.item);
}

class DecreaseCartEvent extends CartProductsEvent {
  final dynamic item;
  DecreaseCartEvent(this.item);
}

class DeleteCartEvent extends CartProductsEvent {
  final dynamic item;
  DeleteCartEvent(this.item);
}

class CartLogoutEvent extends CartProductsEvent{}
