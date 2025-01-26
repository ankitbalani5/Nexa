part of 'cancel_order_bloc.dart';

@immutable
sealed class CancelOrderState {}

final class CancelOrderInitial extends CancelOrderState {}
final class CancelOrderLoading extends CancelOrderState {}
final class CancelOrderSuccess extends CancelOrderState {
  CancelOrderModel reOrderModel;
  CancelOrderSuccess(this.reOrderModel);
}
final class CancelOrderError extends CancelOrderState {
  String error;
  CancelOrderError(this.error);
}