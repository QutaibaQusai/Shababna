import 'package:equatable/equatable.dart';

import '../../domain/repositories/profile_repository.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.errorMessage,
  });

  final bool isLoading;
  final Profile? profile;
  final String? errorMessage;

  ProfileState copyWith({
    bool? isLoading,
    Profile? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, profile, errorMessage];
}
