import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../mappers/profile_mapper.dart';
import '../models/update_profile_details_request_model.dart';

class ProfileRepositoryImpl with RepositoryGuardMixin implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Profile>> getProfile() {
    return guard(() async {
      final response = await _remoteDataSource.getProfile();
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, Profile>> updateDetails({
    String? nationalityId,
    String? cityId,
    String? dateOfBirth,
    ProfileGender? gender,
    String? educationId,
    String? major,
    String? universityName,
    bool? isFirstTimeVolunteer,
    String? nearestLandmark,
    String? district,
    String? neighborhood,
    String? detailedAddress,
    bool? volunteerAwards,
    bool? isAvailableToVolunteer,
    int? estimatedWeeklyHours,
    bool? willSignVolunteerServiceAgreement,
    bool? willProvideNcc,
    List<String>? volunteeringTypeIds,
    String? otherVolunteeringSubjects,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.updateDetails(
        UpdateProfileDetailsRequestModel(
          nationalityId: nationalityId,
          cityId: cityId,
          dateOfBirth: dateOfBirth,
          gender: gender == null ? null : genderToApiValue(gender),
          educationId: educationId,
          major: major,
          universityName: universityName,
          isFirstTimeVolunteer: isFirstTimeVolunteer,
          nearestLandmark: nearestLandmark,
          district: district,
          neighborhood: neighborhood,
          detailedAddress: detailedAddress,
          volunteerAwards: volunteerAwards,
          isAvailableToVolunteer: isAvailableToVolunteer,
          estimatedWeeklyHours: estimatedWeeklyHours,
          willSignVolunteerServiceAgreement: willSignVolunteerServiceAgreement,
          willProvideNcc: willProvideNcc,
          volunteeringTypeIds: volunteeringTypeIds,
          otherVolunteeringSubjects: otherVolunteeringSubjects,
        ),
      );
      return response.toEntity();
    });
  }
}
