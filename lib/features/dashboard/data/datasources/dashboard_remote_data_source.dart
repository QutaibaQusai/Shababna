import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/dashboard_model.dart';

class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<DashboardModel> getDashboard() async {
    final response = await _apiConsumer.get(EndPoints.dashboard);
    return DashboardModel.fromJson(response as Map<String, dynamic>);
  }
}
