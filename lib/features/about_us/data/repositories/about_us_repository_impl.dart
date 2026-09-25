import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/about_us_repository.dart';
import '../datasources/about_us_remote_data_source.dart';

class AboutUsRepositoryImpl with RepositoryGuardMixin implements AboutUsRepository {
  AboutUsRepositoryImpl(this._remoteDataSource);

  final AboutUsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AboutUsContent>> getAboutUs() {
    return guard(() async {
      final response = await _remoteDataSource.getAboutUs();
      return AboutUsContent(
        aboutUsEn: response.aboutUsEn,
        aboutUsAr: response.aboutUsAr,
      );
    });
  }
}
