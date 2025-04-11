part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  const NotificationsStatusChanged(this.status);
}
