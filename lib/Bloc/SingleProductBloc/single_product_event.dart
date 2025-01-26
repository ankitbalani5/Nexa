part of 'single_product_bloc.dart';

@immutable
sealed class SingleProductEvent {}

class SingleProductRefreshEvent extends SingleProductEvent {
  String product_id;
  SingleProductRefreshEvent(this.product_id);
}

class AddWishlistSingleEvent extends SingleProductEvent {
  String product_id;
  AddWishlistSingleEvent(this.product_id);
}

class AddCartEvent extends SingleProductEvent {
  String product_id;
  String quantity;
  String price;
  AddCartEvent(this.product_id, this.quantity, this.price);
}

class IncreaseItemEvent extends SingleProductEvent {
  int counter;
  IncreaseItemEvent(this.counter);
}

class DecreaseItemEvent extends SingleProductEvent {
  int counter;
  DecreaseItemEvent(this.counter);
}

