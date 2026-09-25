import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';

class ProfilePhoneRemoteDataSource {
  ProfilePhoneRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<void> updatePhoneNumber(String phoneNumber) {
    return _apiConsumer.put(EndPoints.phoneNumber, data: {'phoneNumber': phoneNumber});
  }
}
