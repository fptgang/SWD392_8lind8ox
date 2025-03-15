import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/app/main.dart';
import 'package:mobile/data/mapper/generic_mapper.dart';
import 'package:mobile/data/mapper/notification_mapper.dart';
import 'package:mobile/data/models/generic_response_model.dart';
import 'package:mobile/data/models/notification_model.dart';
import 'package:mobile/data/repositories/notification_repository.dart';
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
  Future<PaginationResponseGeneric<NotificationModel>> getNotifications(
      Pageable pageable, String filter, String search) async {
    try {
      GetNotifications200Response? response = await _apiService
          .getNotifications(pageable: pageable, filter: filter, search: search);
      if (response == null) {
        throw Exception('Cannot get notification information');
      }
      PaginationResponseGeneric<NotificationModel>? notificationModels =
          PaginationResponseMapper.toModel(
              dto: response,
              fromDTO: (data) => NotificationMapper.toModel(data));
      return notificationModels;
    } catch (e) {
      throw Exception('Cannot get notification information');
    }
  }

  @override
  Future<NotificationModel> updateNotification(
      int id, NotificationModel notificationModel) async {
    try {
      NotificationDto notificationDto =
          NotificationMapper.toDto(notificationModel);

      final response =
          await _apiService.updateNotification(id, notificationDto);

      if (response == null) {
        throw Exception('Cannot update notification information');
      }
      NotificationModel? notificationModelFromMapper =
          NotificationMapper.toModel(response);
      return notificationModelFromMapper;
    } catch (e) {
      throw Exception('Cannot update notification information');
    }
  }
}
