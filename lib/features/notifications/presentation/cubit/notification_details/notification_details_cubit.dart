import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/repositories/notifications_repository.dart';
import '../unread_count/unread_count_cubit.dart';

class NotificationDetailsState extends Equatable {
  const NotificationDetailsState({
    this.isLoading = false,
    this.notification,
    this.hasError = false,
    this.errorMessage,
  });

  final bool isLoading;
  final AppNotification? notification;
  final bool hasError;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, notification, hasError, errorMessage];
}

class NotificationDetailsCubit extends Cubit<NotificationDetailsState> {
  NotificationDetailsCubit(
    this._repository,
    this._unreadCount, {
    required this.id,
  }) : super(const NotificationDetailsState());

  final NotificationsRepository _repository;
  final UnreadCountCubit _unreadCount;
  final String id;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(const NotificationDetailsState(isLoading: true));

    final result = await _repository.getNotification(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        NotificationDetailsState(
          hasError: true,
          errorMessage: failure is UnexpectedFailure
              ? null
              : failure.displayMessage,
        ),
      ),
      (notification) {
        emit(NotificationDetailsState(notification: notification));
        if (!notification.isRead) _markRead();
      },
    );
  }

  Future<void> _markRead() async {
    _unreadCount.decrement();
    await _repository.markRead(id);
    await _unreadCount.refresh();
  }
}
