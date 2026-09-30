import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notification_permission_service.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repository, this._permissionService) : super(const OnboardingState());

  final OnboardingRepository _repository;
  final NotificationPermissionService _permissionService;

  Future<void> start() async {
    final status = await _safely(_permissionService.current);
    if (isClosed) return;
    emit(state.copyWith(permission: status));
  }

  void pageChanged(int page) {
    if (page == state.page) return;
    emit(state.copyWith(page: page));
  }

  Future<void> requestNotifications() async {
    if (state.isRequestingPermission) return;
    emit(state.copyWith(isRequestingPermission: true));
    final status = await _safely(_permissionService.request);
    if (isClosed) return;
    emit(state.copyWith(
      permission: status,
      isRequestingPermission: false,
      hasRequestedPermission: true,
    ));
  }

  Future<void> complete() => _repository.complete();

  Future<NotificationPermissionStatus> _safely(
    Future<NotificationPermissionStatus> Function() action,
  ) async {
    try {
      return await action();
    } catch (_) {
      return state.permission;
    }
  }
}
