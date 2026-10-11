import 'package:equatable/equatable.dart';

import '../../../domain/repositories/volunteering_opportunities_repository.dart';

enum VolunteeringOpportunitiesListStatus { initial, loading, success, failure }

class VolunteeringOpportunitiesListState extends Equatable {
  const VolunteeringOpportunitiesListState({
    this.status = VolunteeringOpportunitiesListStatus.initial,
    this.typeId,
    this.date,
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final VolunteeringOpportunitiesListStatus status;
  final String? typeId;
  final DateTime? date;
  final List<VolunteeringOpportunitySummary> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == VolunteeringOpportunitiesListStatus.success &&
      hasNextPage &&
      !isLoadingMore &&
      !loadMoreFailed;

  VolunteeringOpportunitiesListState copyWith({
    VolunteeringOpportunitiesListStatus? status,
    List<VolunteeringOpportunitySummary>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return VolunteeringOpportunitiesListState(
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
