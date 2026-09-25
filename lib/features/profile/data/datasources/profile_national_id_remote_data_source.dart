import 'package:dio/dio.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/profile_model.dart';

class ProfileNationalIdRemoteDataSource {
  ProfileNationalIdRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<ProfileModel> updateNationalIdPicture(String filePath) async {
    final response = await _apiConsumer.put(
      EndPoints.nationalId,
      data: {'NationalIdPicture': await MultipartFile.fromFile(filePath)},
      isFormData: true,
    );
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteNationalIdPicture() {
    return _apiConsumer.delete(EndPoints.nationalId);
  }
}
