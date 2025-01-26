part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}
final class NotificationLoading extends NotificationState {}
final class NotificationSuccess extends NotificationState {
  NotificationListModel notificationListModel;
  NotificationSuccess(this.notificationListModel);
}
final class NotificationError extends NotificationState {
  String error;
  NotificationError(this.error);
}
