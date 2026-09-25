import 'package:dio/dio.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/profile_model.dart';

class ProfilePictureRemoteDataSource {
  ProfilePictureRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<ProfileModel> updatePicture(String filePath) async {
    final response = await _apiConsumer.put(
      EndPoints.profilePicture,
      data: {'ProfilePicture': await MultipartFile.fromFile(filePath)},
      isFormData: true,
    );
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deletePicture() {
    return _apiConsumer.delete(EndPoints.profilePicture);
  }
}
