import 'package:equatable/equatable.dart';

import '../../domain/repositories/legal_repository.dart';

class LegalState extends Equatable {
  const LegalState({
    this.isLoading = false,
    this.content,
    this.errorMessage,
  });

  final bool isLoading;
  final LegalContent? content;
  final String? errorMessage;

  LegalState copyWith({
    bool? isLoading,
    LegalContent? content,
    String? errorMessage,
  }) {
    return LegalState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, content, errorMessage];
}
