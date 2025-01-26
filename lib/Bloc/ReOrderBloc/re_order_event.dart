part of 're_order_bloc.dart';

@immutable
sealed class ReOrderEvent {}
class ReOrderRefreshEvent extends ReOrderEvent {
  String order_id;
  ReOrderRefreshEvent(this.order_id);
}
