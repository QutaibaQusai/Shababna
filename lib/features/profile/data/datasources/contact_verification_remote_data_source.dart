import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../auth/domain/verification_channel.dart';

class ContactVerificationRemoteDataSource {
  ContactVerificationRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<int> sendCode(VerificationChannel channel) async {
    final response = await _apiConsumer.post(
      EndPoints.otpSend,
      data: {'channel': channel.apiValue},
    );
    final seconds = response is Map<String, dynamic> ? response['resendAfterSeconds'] : null;
    return switch (seconds) {
      final num value => value.round(),
      final String value => int.tryParse(value) ?? 0,
      _ => 0,
    };
  }

  Future<void> verifyCode(VerificationChannel channel, String code) {
    return _apiConsumer.post(
      EndPoints.otpVerify,
      data: {'channel': channel.apiValue, 'code': code},
    );
  }
}
