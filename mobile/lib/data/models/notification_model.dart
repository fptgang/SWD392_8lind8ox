class NotificationModel {
  final int notificationId;
  final int accountId;
  final String message;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.accountId,
    required this.message,
    required this.createdAt,
    this.updatedAt,
    this.isRead = false,
  });
}
