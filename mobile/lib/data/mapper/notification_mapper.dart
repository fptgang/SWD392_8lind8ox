

import 'package:mobile/data/models/notification_model.dart';
import 'package:openapi/api.dart';

class NotificationMapper{
  static NotificationModel toModel(NotificationDto dto){
    return NotificationModel(
      notificationId: dto.notificationId!,
      accountId: dto.accountId!,
      message: dto.message!,
      createdAt: dto.createdAt!,
      updatedAt: dto.updatedAt,
      isRead: dto.isRead!,
    );
  }

  static NotificationDto toDto(NotificationModel model){
    return NotificationDto(
      notificationId: model.notificationId,
      accountId: model.accountId,
      message: model.message,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isRead: model.isRead,
    );
  }

}