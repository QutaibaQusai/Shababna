import 'package:equatable/equatable.dart';

import '../../../domain/repositories/profile_repository.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.hasError = false,
    this.errorMessage,
    this.pictureVersion = 0,
  });

  final bool isLoading;
  final Profile? profile;
  final bool hasError;
  final String? errorMessage;
  final int pictureVersion;

  String? get pictureCacheKey {
    final current = profile;
    if (current == null || !current.hasProfilePicture) return null;
    return 'profile-picture-${current.id}-$pictureVersion';
  }

  ProfileState copyWith({
    bool? isLoading,
    Profile? profile,
    bool? hasError,
    String? errorMessage,
    int? pictureVersion,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      hasError: hasError ?? false,
      errorMessage: errorMessage,
      pictureVersion: pictureVersion ?? this.pictureVersion,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, hasError, errorMessage, pictureVersion];
}
