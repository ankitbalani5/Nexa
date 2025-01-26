part of 'order_list_bloc.dart';

@immutable
sealed class OrderListState {}

final class OrderListInitial extends OrderListState {}
final class OrderListLoading extends OrderListState {}
final class OrderListSuccess extends OrderListState {
  OrderListModel orderListModel;
  OrderListModel reviewModel;
  OrderListSuccess(this.orderListModel, this.reviewModel);
}
final class OrderListError extends OrderListState {
  String error;
  OrderListError(this.error);
}
