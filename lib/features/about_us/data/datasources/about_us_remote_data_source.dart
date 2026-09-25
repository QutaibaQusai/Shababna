import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/about_us_model.dart';

class AboutUsRemoteDataSource {
  AboutUsRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<AboutUsModel> getAboutUs() async {
    final response = await _apiConsumer.get(EndPoints.generalContent);
    return AboutUsModel.fromJson(response as Map<String, dynamic>);
  }
}
