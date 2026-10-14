import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/notifications/notification_permission_service.dart';
import '../../../../../core/notifications/push_device_registrar.dart';
import '../../../../../core/notifications/push_message.dart';
import '../../../domain/repositories/notifications_repository.dart';
import 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit(
    this._repository,
    this._permissionService,
    this._registrar,
  ) : super(const NotificationSettingsState());

  final NotificationsRepository _repository;
  final NotificationPermissionService _permissionService;
  final PushDeviceRegistrar _registrar;

  Future<void> load() async {
    emit(state.copyWith(status: NotificationSettingsStatus.loading));
    final permission = await _currentPermission();
    final result = await _repository.getPreferences();
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationSettingsStatus.failure,
          permission: permission,
          errorMessage: _messageOf(failure),
        ),
      ),
      (preferences) => emit(
        state.copyWith(
          status: NotificationSettingsStatus.ready,
          preferences: preferences,
          permission: permission,
        ),
      ),
    );
  }

  Future<void> refreshPermission() async {
    final permission = await _currentPermission();
    if (isClosed || permission == state.permission) return;
    emit(state.copyWith(permission: permission));
    if (permission == NotificationPermissionStatus.granted) {
      await _registrar.refresh(force: true);
    }
  }

  Future<void> requestPermission() async {
    final permission = await _requestPermission();
    if (isClosed) return;
    emit(state.copyWith(permission: permission));
    if (permission == NotificationPermissionStatus.granted) {
      await _registrar.refresh(force: true);
    }
  }

  Future<void> toggle(NotificationPreference preference) async {
    final previous = state.preferences;
    if (previous == null) return;

    final updated = previous.toggled(preference);
    emit(state.copyWith(preferences: updated));

    final result = await _repository.updatePreferences(updated);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          preferences: previous,
          feedback: NotificationSettingsError(_messageOf(failure)),
        ),
      ),
      (saved) => emit(state.copyWith(preferences: saved)),
    );
  }

  Future<void> sendTest() async {
    if (state.isSendingTest) return;
    emit(state.copyWith(isSendingTest: true));

    final result = await _repository.sendTest(type: NotificationType.general);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isSendingTest: false,
          feedback: NotificationSettingsError(_messageOf(failure)),
        ),
      ),
      (_) => emit(
        state.copyWith(
          isSendingTest: false,
          feedback: const NotificationTestSent(),
        ),
      ),
    );
  }

  Future<NotificationPermissionStatus> _currentPermission() async {
    try {
      return await _permissionService.current();
    } catch (_) {
      return state.permission;
    }
  }

  Future<NotificationPermissionStatus> _requestPermission() async {
    try {
      return await _permissionService.request();
    } catch (_) {
      return state.permission;
    }
  }

  String? _messageOf(Failure failure) =>
      failure is UnexpectedFailure ? null : failure.displayMessage;
}
