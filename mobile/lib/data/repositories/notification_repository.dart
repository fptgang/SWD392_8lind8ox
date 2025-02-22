

import 'package:injectable/injectable.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/notification_model.dart';
import 'package:openapi/api.dart';

@injectable
@Singleton()
abstract class NotificationRepository {
  Future<NotificationModel> getNotificationById(int id);
  Future<PaginationResponseGeneric<GetNotifications200Response>> getNotifications(Pageable pageable, String filter, String search);
}