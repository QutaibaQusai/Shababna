import 'package:equatable/equatable.dart';

import '../../../domain/repositories/notifications_repository.dart';

enum NotificationsListStatus { initial, loading, success, failure }

class NotificationsListState extends Equatable {
  const NotificationsListState({
    this.status = NotificationsListStatus.initial,
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final NotificationsListStatus status;
  final List<AppNotification> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == NotificationsListStatus.success &&
      hasNextPage &&
      !isLoadingMore &&
      !loadMoreFailed;

  NotificationsListState copyWith({
    NotificationsListStatus? status,
    List<AppNotification>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return NotificationsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    page,
    hasNextPage,
    isLoadingMore,
    loadMoreFailed,
    errorMessage,
  ];
}
