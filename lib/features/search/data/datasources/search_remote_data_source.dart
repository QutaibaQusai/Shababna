import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../domain/repositories/search_repository.dart';
import '../models/global_search_response_model.dart';

class SearchRemoteDataSource {
  SearchRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<GlobalSearchResponseModel> search({
    required String query,
    required Set<SearchCategory> categories,
    required int perType,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.search,
      queryParameters: {
        'Q': query,
        'Types': categories.map(_apiType).toList(),
        'PerType': perType,
      },
    );
    return GlobalSearchResponseModel.fromJson(response as Map<String, dynamic>);
  }

  String _apiType(SearchCategory category) => switch (category) {
        SearchCategory.volunteeringOpportunities => 'Events',
        SearchCategory.news => 'News',
        SearchCategory.faq => 'Faq',
      };
}
