import 'package:dio/dio.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../models/update_profile_details_request_model.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<ProfileModel> getProfile() async {
    final response = await _apiConsumer.get(EndPoints.profile);
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<ProfileModel> updateDetails(UpdateProfileDetailsRequestModel request) async {
    final response = await _apiConsumer.put(EndPoints.profileDetails, data: request.toJson());
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> updatePhoneNumber(String phoneNumber) {
    return _apiConsumer.put(EndPoints.phoneNumber, data: {'phoneNumber': phoneNumber});
  }

  Future<ProfileModel> uploadAttachment(ProfileAttachment attachment, String filePath) async {
    final response = await _apiConsumer.put(
      _endpointOf(attachment),
      data: {_fieldOf(attachment): await MultipartFile.fromFile(filePath)},
      isFormData: true,
    );
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteAttachment(ProfileAttachment attachment) {
    return _apiConsumer.delete(_endpointOf(attachment));
  }

  Future<void> deleteAccount({required String currentPassword, String? reason}) {
    final trimmedReason = reason?.trim() ?? '';
    return _apiConsumer.post(
      EndPoints.deleteAccount,
      data: {
        'currentPassword': currentPassword,
        if (trimmedReason.isNotEmpty) 'reason': trimmedReason,
      },
    );
  }

  String _endpointOf(ProfileAttachment attachment) => switch (attachment) {
        ProfileAttachment.picture => EndPoints.profilePicture,
        ProfileAttachment.cv => EndPoints.cv,
        ProfileAttachment.nationalId => EndPoints.nationalId,
      };

  String _fieldOf(ProfileAttachment attachment) => switch (attachment) {
        ProfileAttachment.picture => 'ProfilePicture',
        ProfileAttachment.cv => 'Cv',
        ProfileAttachment.nationalId => 'NationalIdPicture',
      };
}
