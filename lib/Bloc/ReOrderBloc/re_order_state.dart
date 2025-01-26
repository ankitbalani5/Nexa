part of 're_order_bloc.dart';

@immutable
sealed class ReOrderState {}

final class ReOrderInitial extends ReOrderState {}
final class ReOrderLoading extends ReOrderState {}
final class ReOrderSuccess extends ReOrderState {
  ReOrderModel reOrderModel;
  ReOrderSuccess(this.reOrderModel);
}
final class ReOrderError extends ReOrderState {
  String error;
  ReOrderError(this.error);
}
