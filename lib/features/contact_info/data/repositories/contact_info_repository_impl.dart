import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/contact_info_repository.dart';
import '../datasources/contact_info_remote_data_source.dart';

class ContactInfoRepositoryImpl with RepositoryGuardMixin implements ContactInfoRepository {
  ContactInfoRepositoryImpl(this._remoteDataSource);

  final ContactInfoRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ContactInfo>> getContactInfo() {
    return guard(() async {
      final response = await _remoteDataSource.getContactInfo();
      return ContactInfo(
        email: response.email,
        complaintsEmail: response.complaintsEmail,
        phoneNumber: response.phoneNumber,
        complaintsPhoneNumber: response.complaintsPhoneNumber,
        address: response.address,
        latitude: response.latitude,
        longitude: response.longitude,
        googleMapsUrl: response.googleMapsUrl,
      );
    });
  }
}
