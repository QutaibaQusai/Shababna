import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/session/auth_status.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../utils/failure_message.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository, AuthSessionCubit authSession) : super(const ProfileState()) {
    _sessionSubscription = authSession.stream.listen((status) {
      if (status == AuthStatus.unauthenticated) reset();
    });
  }

  final ProfileRepository _repository;
  late final StreamSubscription<AuthStatus> _sessionSubscription;
  int _session = 0;

  Future<void> ensureLoaded() async {
    if (state.profile != null || state.isLoading) return;
    await refresh();
  }

  Future<void> refresh({bool silent = false}) async {
    final session = _session;
    if (!silent || state.profile == null) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }

    final result = await _repository.getProfile();
    if (isClosed || session != _session) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          hasError: state.profile == null,
          errorMessage: state.profile == null ? failure.userMessage : null,
        ),
      ),
      (profile) => _emitProfile(profile),
    );
  }

  void replace(Profile profile, {bool pictureChanged = false}) {
    _emitProfile(profile, pictureChanged: pictureChanged);
  }

  void patch(Profile Function(Profile profile) update) {
    final current = state.profile;
    if (current == null) return;
    emit(state.copyWith(profile: update(current)));
  }

  Future<void> reset() async {
    _session++;
    await _evictPicture();
    emit(const ProfileState());
  }

  void _emitProfile(Profile profile, {bool pictureChanged = false}) {
    final previous = state.profile;
    final changed = pictureChanged ||
        previous == null ||
        previous.hasProfilePicture != profile.hasProfilePicture ||
        previous.profilePictureUrl != profile.profilePictureUrl;

    if (changed && previous != null) _evictPicture();

    emit(state.copyWith(
      isLoading: false,
      profile: profile,
      errorMessage: null,
      pictureVersion: changed && previous != null ? DateTime.now().millisecondsSinceEpoch : null,
    ));
  }

  Future<void> _evictPicture() async {
    final url = state.profile?.profilePictureUrl;
    final key = state.pictureCacheKey;
    if (url == null || key == null) return;
    await CachedNetworkImage.evictFromCache(url, cacheKey: key);
  }

  @override
  Future<void> close() {
    _sessionSubscription.cancel();
    return super.close();
  }
}
