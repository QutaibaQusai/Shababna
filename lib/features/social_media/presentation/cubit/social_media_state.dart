import 'package:equatable/equatable.dart';

import '../../domain/repositories/social_media_repository.dart';

class SocialMediaState extends Equatable {
  const SocialMediaState({
    this.isLoading = false,
    this.links,
    this.errorMessage,
  });

  final bool isLoading;
  final SocialMediaLinks? links;
  final String? errorMessage;

  SocialMediaState copyWith({
    bool? isLoading,
    SocialMediaLinks? links,
    String? errorMessage,
  }) {
    return SocialMediaState(
      isLoading: isLoading ?? this.isLoading,
      links: links ?? this.links,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, links, errorMessage];
}
