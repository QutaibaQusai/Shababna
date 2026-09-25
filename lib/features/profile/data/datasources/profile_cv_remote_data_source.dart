import 'package:dio/dio.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/profile_model.dart';

class ProfileCvRemoteDataSource {
  ProfileCvRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<ProfileModel> updateCv(String filePath) async {
    final response = await _apiConsumer.put(
      EndPoints.cv,
      data: {'Cv': await MultipartFile.fromFile(filePath)},
      isFormData: true,
    );
    return ProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteCv() {
    return _apiConsumer.delete(EndPoints.cv);
  }
}
