part of 'order_list_bloc.dart';

@immutable
sealed class OrderListEvent {}
class OrderListLoadEvent extends OrderListEvent {
  String status;
  OrderListLoadEvent({this.status = 'all'});
}
class ClearDataEvent extends OrderListEvent {

  ClearDataEvent();
}

class CancelOrderEvent extends OrderListEvent {
  BuildContext context;
  String order_id;
  CancelOrderEvent(this.context, this.order_id);
}
