import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_lookups_repository.dart';
import '../datasources/profile_lookups_remote_data_source.dart';

class ProfileLookupsRepositoryImpl with RepositoryGuardMixin implements ProfileLookupsRepository {
  ProfileLookupsRepositoryImpl(this._remoteDataSource);

  final ProfileLookupsRemoteDataSource _remoteDataSource;

  List<Country>? _countries;
  List<City>? _cities;
  List<Education>? _educations;
  List<VolunteeringType>? _volunteeringTypes;

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    final cached = _countries;
    if (cached != null) return Right(cached);

    final result = await guard(() async {
      final response = await _remoteDataSource.getCountries();
      return response
          .where((item) => item.isActive)
          .map((item) => Country(
                id: item.id,
                nameAr: item.nameAr,
                nameEn: item.nameEn,
                countryCode: item.countryCode,
              ))
          .toList();
    });
    result.fold((_) {}, (items) => _countries = items);
    return result;
  }

  @override
  Future<Either<Failure, List<City>>> getCities() async {
    final cached = _cities;
    if (cached != null) return Right(cached);

    final result = await guard(() async {
      final response = await _remoteDataSource.getCities();
      return response
          .where((item) => item.isActive)
          .map((item) => City(id: item.id, nameAr: item.nameAr, nameEn: item.nameEn))
          .toList();
    });
    result.fold((_) {}, (items) => _cities = items);
    return result;
  }

  @override
  Future<Either<Failure, List<Education>>> getEducations() async {
    final cached = _educations;
    if (cached != null) return Right(cached);

    final result = await guard(() async {
      final response = await _remoteDataSource.getEducations();
      final active = response.where((item) => item.isActive).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      return active
          .map((item) => Education(
                id: item.id,
                nameAr: item.nameAr,
                nameEn: item.nameEn,
                isMajorRequired: item.isMajorRequired,
              ))
          .toList();
    });
    result.fold((_) {}, (items) => _educations = items);
    return result;
  }

  @override
  Future<Either<Failure, List<VolunteeringType>>> getVolunteeringTypes() async {
    final cached = _volunteeringTypes;
    if (cached != null) return Right(cached);

    final result = await guard(() async {
      final response = await _remoteDataSource.getVolunteeringTypes();
      final active = response.where((item) => item.isActive).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      return active
          .map((item) => VolunteeringType(id: item.id, nameAr: item.nameAr, nameEn: item.nameEn))
          .toList();
    });
    result.fold((_) {}, (items) => _volunteeringTypes = items);
    return result;
  }

  @override
  Future<Either<Failure, List<PhoneCode>>> getPhoneCodes() {
    return guard(() async {
      final response = await _remoteDataSource.getPhoneCodes();
      return response
          .map((item) => PhoneCode(
                countryName: item.countryName,
                countryCode: item.countryCode,
                callingCode: item.callingCode,
                flag: item.flag,
                nationalNumberLength: item.nationalNumberLength,
                mobilePrefixes: item.mobilePrefixes,
              ))
          .toList();
    });
  }
}
