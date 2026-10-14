import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../models/notification_models.dart';

class NotificationsRemoteDataSource {
  NotificationsRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<PagedResult<NotificationItemModel>> getNotifications({
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.notifications,
      queryParameters: {'Page': page, 'PageSize': pageSize},
    );
    return PagedResult.fromJson(
      response as Map<String, dynamic>,
      NotificationItemModel.fromJson,
    );
  }

  Future<NotificationItemModel> getNotification(String id) async {
    final response = await _apiConsumer.get(EndPoints.notificationById(id));
    return NotificationItemModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> markRead(String id) =>
      _apiConsumer.post(EndPoints.notificationRead(id));

  Future<int> getUnreadCount() async {
    final response = await _apiConsumer.get(EndPoints.notificationsUnreadCount);
    final count = response is Map<String, dynamic> ? response['count'] : null;
    return switch (count) {
      final num value => value.toInt(),
      final String value => int.tryParse(value) ?? 0,
      _ => 0,
    };
  }

  Future<NotificationPreferencesModel> getPreferences() async {
    final response = await _apiConsumer.get(EndPoints.notificationPreferences);
    return NotificationPreferencesModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  Future<NotificationPreferencesModel> updatePreferences(
    NotificationPreferencesModel preferences,
  ) async {
    final response = await _apiConsumer.put(
      EndPoints.notificationPreferences,
      data: preferences.toJson(),
    );
    return NotificationPreferencesModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  Future<void> registerDevice({
    required String token,
    required String deviceId,
    required String platform,
    required String language,
  }) {
    return _apiConsumer.put(
      EndPoints.notificationDeviceToken,
      data: {
        'token': token,
        'deviceId': deviceId,
        'platform': platform,
        'language': language,
      },
    );
  }
}
