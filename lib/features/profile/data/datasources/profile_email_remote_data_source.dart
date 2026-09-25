import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/email_change_response_model.dart';

class ProfileEmailRemoteDataSource {
  ProfileEmailRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<EmailChangeResponseModel> changeEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    final response = await _apiConsumer.post(
      EndPoints.changeEmail,
      data: {'currentPassword': currentPassword, 'newEmail': newEmail},
    );
    return EmailChangeResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> verifyEmailChange(String code) {
    return _apiConsumer.post(EndPoints.verifyEmailChange, data: {'code': code});
  }

  Future<EmailChangeResponseModel> resendEmailChangeCode() async {
    final response = await _apiConsumer.post(EndPoints.resendEmailChangeCode);
    return EmailChangeResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
