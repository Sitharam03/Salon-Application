enum NotificationType { booking, review, profile, other }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
  });
}
