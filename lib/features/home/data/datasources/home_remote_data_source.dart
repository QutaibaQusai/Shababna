import 'package:intl/intl.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/home_models.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._apiConsumer);

  static const _slidesPageSize = 10;
  static const _featuredPageSize = 10;
  static const _newsPageSize = 3;
  static const _tasksPageSize = 100;
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  final ApiConsumer _apiConsumer;

  Future<HomeProfileModel> getProfile() async {
    final response = await _apiConsumer.get(EndPoints.profile);
    return HomeProfileModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<HomeSlideModel>> getSlides() async {
    final response = await _apiConsumer.get(
      EndPoints.sliders,
      queryParameters: {'Page': 1, 'PageSize': _slidesPageSize},
    );
    return parseHomeItems(response).map(HomeSlideModel.fromJson).toList();
  }

  Future<List<HomeTaskModel>> getAssignedTasks() async {
    final response = await _apiConsumer.get(
      EndPoints.volunteeringOpportunityTasks,
      queryParameters: {'Page': 1, 'PageSize': _tasksPageSize, 'AssignedOnly': true},
    );
    return parseHomeItems(response).map(HomeTaskModel.fromJson).toList();
  }

  Future<List<HomeVolunteeringOpportunityModel>> getSuggestedVolunteeringOpportunities() =>
      _volunteeringOpportunities(EndPoints.volunteeringOpportunitiesSuggested, {
        'Page': 1,
        'PageSize': _featuredPageSize,
      });

  Future<List<HomeVolunteeringOpportunityModel>> getUpcomingVolunteeringOpportunities() =>
      _volunteeringOpportunities(EndPoints.volunteeringOpportunitiesUpcoming, {
        'Page': 1,
        'PageSize': _featuredPageSize,
      });

  Future<List<HomeOccasionModel>> getOccasionsOn(DateTime day) async {
    final response = await _apiConsumer.get(
      EndPoints.holidays,
      queryParameters: {'Date': _dateFormat.format(day)},
    );
    return parseHomeList(response).map(HomeOccasionModel.fromJson).toList();
  }

  Future<List<HomeNewsModel>> getLatestNews() async {
    final response = await _apiConsumer.get(
      EndPoints.news,
      queryParameters: {'Page': 1, 'PageSize': _newsPageSize},
    );
    return parseHomeItems(response).map(HomeNewsModel.fromJson).toList();
  }

  Future<List<HomeVolunteeringOpportunityModel>> _volunteeringOpportunities(
    String endpoint,
    Map<String, dynamic> query,
  ) async {
    final response = await _apiConsumer.get(endpoint, queryParameters: query);
    return parseHomeItems(response).map(HomeVolunteeringOpportunityModel.fromJson).toList();
  }
}
