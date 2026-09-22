import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/legal_content_model.dart';

class LegalRemoteDataSource {
  LegalRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<LegalContentModel> getContent() async {
    final response = await _apiConsumer.get(EndPoints.generalContent);
    return LegalContentModel.fromJson(response as Map<String, dynamic>);
  }
}
