import 'package:equatable/equatable.dart';

import '../../domain/repositories/search_repository.dart';

enum GlobalSearchStatus { idle, loading, success, failure }

class GlobalSearchState extends Equatable {
  const GlobalSearchState({
    this.status = GlobalSearchStatus.idle,
    this.query = '',
    this.category,
    this.results = const GlobalSearchResults.empty(),
    this.errorMessage,
  });

  final GlobalSearchStatus status;
  final String query;
  final SearchCategory? category;
  final GlobalSearchResults results;
  final String? errorMessage;

  bool get isAll => category == null;

  @override
  List<Object?> get props => [status, query, category, results, errorMessage];
}
