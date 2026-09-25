import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/social_media_links_model.dart';

class SocialMediaRemoteDataSource {
  SocialMediaRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<SocialMediaLinksModel> getSocialMediaLinks() async {
    final response = await _apiConsumer.get(EndPoints.socialMediaLinks);
    return SocialMediaLinksModel.fromJson(response as Map<String, dynamic>);
  }
}
