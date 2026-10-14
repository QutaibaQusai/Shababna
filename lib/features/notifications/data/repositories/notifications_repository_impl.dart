import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../../../core/notifications/push_message.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../mappers/notifications_mapper.dart';

class NotificationsRepositoryImpl
    with RepositoryGuardMixin
    implements NotificationsRepository {
  NotificationsRepositoryImpl(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PagedResult<AppNotification>>> getNotifications({
    required int page,
    required int pageSize,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.getNotifications(
        page: page,
        pageSize: pageSize,
      );
      return PagedResult(
        items: response.items.map((item) => item.toEntity()).toList(),
        page: response.page,
        pageSize: response.pageSize,
        totalCount: response.totalCount,
        hasNextPage: response.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, AppNotification>> getNotification(String id) {
    return guard(
      () async => (await _remoteDataSource.getNotification(id)).toEntity(),
    );
  }

  @override
  Future<Either<Failure, void>> markRead(String id) {
    return guard(() => _remoteDataSource.markRead(id));
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() {
    return guard(_remoteDataSource.getUnreadCount);
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() {
    return guard(
      () async => (await _remoteDataSource.getPreferences()).toEntity(),
    );
  }

  @override
  Future<Either<Failure, NotificationPreferences>> updatePreferences(
    NotificationPreferences preferences,
  ) {
    return guard(
      () async =>
          (await _remoteDataSource.updatePreferences(preferences.toModel()))
              .toEntity(),
    );
  }

  @override
  Future<Either<Failure, void>> registerDevice({
    required String token,
    required String deviceId,
    required DevicePlatform platform,
    required String language,
  }) {
    return guard(
      () => _remoteDataSource.registerDevice(
        token: token,
        deviceId: deviceId,
        platform: platform.name,
        language: language,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> sendTest({
    required NotificationType type,
    String? targetId,
  }) {
    return guard(
      () => _remoteDataSource.sendTest(type: type.name, targetId: targetId),
    );
  }
}
