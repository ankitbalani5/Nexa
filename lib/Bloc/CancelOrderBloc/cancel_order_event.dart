part of 'cancel_order_bloc.dart';

@immutable
sealed class CancelOrderEvent {}
class CancelOrderRefreshEvent extends CancelOrderEvent {
  BuildContext context;
  String order_id;
  CancelOrderRefreshEvent(this.context, this.order_id);
}