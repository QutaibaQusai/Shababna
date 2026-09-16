import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/country_phone_code_model.dart';
import '../models/email_request_model.dart';
import '../models/login_request_model.dart';
import '../models/message_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/token_response_model.dart';
import '../models/verify_email_request_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<TokenResponseModel> login(LoginRequestModel request) async {
    final response = await _apiConsumer.post(
      EndPoints.login,
      data: request.toJson(),
    );
    return TokenResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await _apiConsumer.post(
      EndPoints.register,
      data: request.toFormMap(),
      isFormData: true,
    );
    return RegisterResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> verifyEmail(VerifyEmailRequestModel request) {
    return _apiConsumer.post(EndPoints.verifyEmail, data: request.toJson());
  }

  Future<MessageResponseModel> resendEmailVerification(
    EmailRequestModel request,
  ) async {
    final response = await _apiConsumer.post(
      EndPoints.resendEmailVerification,
      data: request.toJson(),
    );
    return MessageResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<MessageResponseModel> forgotPassword(EmailRequestModel request) async {
    final response = await _apiConsumer.post(
      EndPoints.forgotPassword,
      data: request.toJson(),
    );
    return MessageResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> resetPassword(ResetPasswordRequestModel request) {
    return _apiConsumer.post(EndPoints.resetPassword, data: request.toJson());
  }

  Future<List<CountryPhoneCodeModel>> getPhoneCodes() async {
    final response = await _apiConsumer.get(EndPoints.countryPhoneCodes);
    return (response as List)
        .map((item) => CountryPhoneCodeModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
