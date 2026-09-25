import 'package:equatable/equatable.dart';

import '../../domain/repositories/about_us_repository.dart';

class AboutUsState extends Equatable {
  const AboutUsState({
    this.isLoading = false,
    this.content,
    this.errorMessage,
  });

  final bool isLoading;
  final AboutUsContent? content;
  final String? errorMessage;

  AboutUsState copyWith({
    bool? isLoading,
    AboutUsContent? content,
    String? errorMessage,
  }) {
    return AboutUsState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, content, errorMessage];
}
