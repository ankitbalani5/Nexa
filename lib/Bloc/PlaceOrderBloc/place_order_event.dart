part of 'place_order_bloc.dart';

@immutable
sealed class PlaceOrderEvent {}

class PlaceOrderRefreshEvent extends PlaceOrderEvent{
  String cart_id;
  String sub_total_amount;
  String item_discount_amount;
  String total_amount;
  String payment_mode;
  String delivery_option;
  String address_id;
  String coupon_id;
  String message;
  String warehouse_id;
  PlaceOrderRefreshEvent(this.cart_id, this.sub_total_amount, this.item_discount_amount,
      this.total_amount, this.payment_mode, this.delivery_option, this.address_id,
      this.coupon_id, this.message, {this.warehouse_id = ''});
}
