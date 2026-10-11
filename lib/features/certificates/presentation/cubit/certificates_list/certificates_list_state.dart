import 'package:equatable/equatable.dart';

import '../../../domain/repositories/certificates_repository.dart';

enum CertificatesListStatus { initial, loading, success, failure }

class CertificatesListState extends Equatable {
  const CertificatesListState({
    this.status = CertificatesListStatus.initial,
    this.items = const [],
    this.page = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final CertificatesListStatus status;
  final List<Certificate> items;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  bool get canLoadMore =>
      status == CertificatesListStatus.success && hasNextPage && !isLoadingMore && !loadMoreFailed;

  CertificatesListState copyWith({
    CertificatesListStatus? status,
    List<Certificate>? items,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return CertificatesListState(
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
