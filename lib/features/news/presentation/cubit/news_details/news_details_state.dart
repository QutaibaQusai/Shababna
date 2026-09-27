import 'package:equatable/equatable.dart';

import '../../../domain/repositories/news_repository.dart';

class NewsDetailsState extends Equatable {
  const NewsDetailsState({
    this.isLoading = false,
    this.article,
    this.hasError = false,
    this.errorMessage,
  });

  final bool isLoading;
  final NewsArticle? article;
  final bool hasError;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, article, hasError, errorMessage];
}
