import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/change_password_request_model.dart';

class ChangePasswordRemoteDataSource {
  ChangePasswordRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<void> changePassword(ChangePasswordRequestModel request) {
    return _apiConsumer.post(EndPoints.changePassword, data: request.toJson());
  }
}
