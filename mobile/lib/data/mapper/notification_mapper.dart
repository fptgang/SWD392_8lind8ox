

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

}