import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
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
}
