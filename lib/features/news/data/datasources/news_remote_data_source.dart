import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../models/news_model.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<PagedResult<NewsModel>> getNews({required int page, required int pageSize}) async {
    final response = await _apiConsumer.get(
      EndPoints.news,
      queryParameters: {'Page': page, 'PageSize': pageSize},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, NewsModel.fromJson);
  }

  Future<NewsModel> getNewsById(String id) async {
    final response = await _apiConsumer.get(EndPoints.newsById(id));
    return NewsModel.fromJson(response as Map<String, dynamic>);
  }
}
