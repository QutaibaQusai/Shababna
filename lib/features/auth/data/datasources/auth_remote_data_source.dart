import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/check_registration_request_model.dart';
import '../models/country_phone_code_model.dart';
import '../models/email_request_model.dart';
import '../models/login_request_model.dart';
import '../models/message_response_model.dart';
import '../models/register_request_model.dart';
import '../models/reset_password_request_model.dart';
import '../models/token_response_model.dart';
import '../models/verify_registration_code_request_model.dart';
import '../models/verify_registration_code_response_model.dart';
import '../models/verify_reset_code_request_model.dart';
import '../models/verify_reset_code_response_model.dart';

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

  Future<MessageResponseModel> checkRegistration(
    CheckRegistrationRequestModel request,
  ) async {
    final response = await _apiConsumer.post(
      EndPoints.checkRegistration,
      data: request.toJson(),
    );
    return MessageResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VerifyRegistrationCodeResponseModel> verifyRegistrationCode(
    VerifyRegistrationCodeRequestModel request,
  ) async {
    final response = await _apiConsumer.post(
      EndPoints.verifyRegistrationCode,
      data: request.toJson(),
    );
    return VerifyRegistrationCodeResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> register(RegisterRequestModel request) {
    return _apiConsumer.post(
      EndPoints.register,
      data: request.toFormMap(),
      isFormData: true,
    );
  }

  Future<MessageResponseModel> forgotPassword(EmailRequestModel request) async {
    final response = await _apiConsumer.post(
      EndPoints.forgotPassword,
      data: request.toJson(),
    );
    return MessageResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VerifyResetCodeResponseModel> verifyResetCode(
    VerifyResetCodeRequestModel request,
  ) async {
    final response = await _apiConsumer.post(
      EndPoints.verifyResetCode,
      data: request.toJson(),
    );
    return VerifyResetCodeResponseModel.fromJson(response as Map<String, dynamic>);
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

  Future<void> logout() {
    return _apiConsumer.post(EndPoints.logout);
  }
}
