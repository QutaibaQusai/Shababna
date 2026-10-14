import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/notifications/push_notification_service.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/session/auth_status.dart';
import '../../../domain/repositories/notifications_repository.dart';

class UnreadCountCubit extends Cubit<int> {
  UnreadCountCubit(
    this._repository,
    this._session,
    PushNotificationService push,
  ) : super(0) {
    _subscriptions
      ..add(_session.stream.listen(_onSessionChanged))
      ..add(push.foregroundMessages.listen((_) => refresh()));
    _onSessionChanged(_session.state);
  }

  final NotificationsRepository _repository;
  final AuthSessionCubit _session;
  final _subscriptions = <StreamSubscription<Object?>>[];

  Future<void> refresh() async {
    if (!_session.state.isAuthenticated) return;
    final result = await _repository.getUnreadCount();
    if (isClosed || !_session.state.isAuthenticated) return;
    result.fold((_) {}, emit);
  }

  void decrement() {
    if (state > 0) emit(state - 1);
  }

  void _onSessionChanged(AuthStatus status) {
    if (status.isAuthenticated) {
      refresh();
    } else {
      emit(0);
    }
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    return super.close();
  }
}
