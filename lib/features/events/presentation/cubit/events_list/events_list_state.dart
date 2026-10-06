import 'package:equatable/equatable.dart';

import '../../../domain/repositories/events_repository.dart';

enum EventsListStatus { initial, loading, success, failure }

class EventsListState extends Equatable {
  const EventsListState({
    this.status = EventsListStatus.initial,
    this.typeId,
    this.date,
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final EventsListStatus status;
  final String? typeId;
  final DateTime? date;
  final List<EventSummary> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == EventsListStatus.success && hasNextPage && !isLoadingMore && !loadMoreFailed;

  EventsListState copyWith({
    EventsListStatus? status,
    List<EventSummary>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return EventsListState(
      status: status ?? this.status,
      typeId: typeId,
      date: date,
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
    typeId,
    date,
    items,
    page,
    hasNextPage,
    isLoadingMore,
    loadMoreFailed,
    errorMessage,
  ];
}
