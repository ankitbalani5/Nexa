part of 'place_order_bloc.dart';

@immutable
sealed class PlaceOrderState {}

final class PlaceOrderInitial extends PlaceOrderState {}
final class PlaceOrderLoading extends PlaceOrderState {}
final class PlaceOrderSuccess extends PlaceOrderState {
  PlaceOrderModel placeOrderModel;
  PlaceOrderSuccess(this.placeOrderModel);
}
final class PlaceOrderError extends PlaceOrderState {
  String error;
  PlaceOrderError(this.error);
}
