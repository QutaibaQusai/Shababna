import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/social_media_repository.dart';
import '../datasources/social_media_remote_data_source.dart';

class SocialMediaRepositoryImpl with RepositoryGuardMixin implements SocialMediaRepository {
  SocialMediaRepositoryImpl(this._remoteDataSource);

  final SocialMediaRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, SocialMediaLinks>> getSocialMediaLinks() {
    return guard(() async {
      final response = await _remoteDataSource.getSocialMediaLinks();
      return SocialMediaLinks(
        facebook: response.facebook,
        twitter: response.twitter,
        instagram: response.instagram,
        threads: response.threads,
        snapchat: response.snapchat,
        linkedIn: response.linkedIn,
        tikTok: response.tikTok,
        youTube: response.youTube,
      );
    });
  }
}
