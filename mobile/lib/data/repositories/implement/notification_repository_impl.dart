

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/notification_model.dart';
import 'package:mobile/data/repositories/notification_repository.dart';
import 'package:mobile/main.dart';
import 'package:openapi/api.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  var box = Hive.box('authentication');
  final DefaultApi _apiService = getIt<DefaultApi>();

  NotificationRepositoryImpl() {
    _apiService.apiClient.authentication?.applyToParams([], {
      "Authorization": "Bearer ${box.get('loginToken')}",
    });
  }

  @override
  Future<NotificationModel> getNotificationById(int id) {
    // TODO: implement getNotificationById
    throw UnimplementedError();
  }

  @override
  Future<PaginationResponseGeneric<GetNotifications200Response>> getNotifications(
      Pageable pageable, String filter, String search) {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }

  
}