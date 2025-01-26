part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}
class GetNotificationEvent extends NotificationEvent {}
class DeleteNotificationEvent extends NotificationEvent {
  BuildContext context;
  var notification_id;
  DeleteNotificationEvent(this.context , this.notification_id);
}
