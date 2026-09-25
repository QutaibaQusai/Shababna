import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_lookups_repository.dart';
import '../datasources/profile_lookups_remote_data_source.dart';

class ProfileLookupsRepositoryImpl with RepositoryGuardMixin implements ProfileLookupsRepository {
  ProfileLookupsRepositoryImpl(this._remoteDataSource);

  final ProfileLookupsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<Country>>> getCountries() {
    return guard(() async {
      final response = await _remoteDataSource.getCountries();
      return response
          .map((item) => Country(
                id: item.id,
                nameAr: item.nameAr,
                nameEn: item.nameEn,
                countryCode: item.countryCode,
              ))
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<City>>> getCities() {
    return guard(() async {
      final response = await _remoteDataSource.getCities();
      return response.map((item) => City(id: item.id, nameAr: item.nameAr, nameEn: item.nameEn)).toList();
    });
  }

  @override
  Future<Either<Failure, List<Education>>> getEducations() {
    return guard(() async {
      final response = await _remoteDataSource.getEducations();
      return response
          .map((item) => Education(
                id: item.id,
                nameAr: item.nameAr,
                nameEn: item.nameEn,
                isMajorRequired: item.isMajorRequired,
              ))
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<VolunteeringType>>> getVolunteeringTypes() {
    return guard(() async {
      final response = await _remoteDataSource.getVolunteeringTypes();
      return response
          .map((item) => VolunteeringType(id: item.id, nameAr: item.nameAr, nameEn: item.nameEn))
          .toList();
    });
  }
}
