import 'package:intl/intl.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/home_models.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._apiConsumer);

  static const _slidesPageSize = 10;
  static const _featuredPageSize = 10;
  static const _dayEventsPageSize = 20;
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
      EndPoints.eventTasks,
      queryParameters: {'Page': 1, 'PageSize': _tasksPageSize, 'AssignedOnly': true},
    );
    return parseHomeItems(response).map(HomeTaskModel.fromJson).toList();
  }

  Future<List<HomeEventModel>> getSuggestedEvents() =>
      _events(EndPoints.eventsSuggested, {'Page': 1, 'PageSize': _featuredPageSize});

  Future<List<HomeEventModel>> getUpcomingEvents() =>
      _events(EndPoints.events, {'Page': 1, 'PageSize': _featuredPageSize});

  Future<List<HomeEventModel>> getEventsOn(DateTime day) => _events(EndPoints.eventsByDate, {
    'Date': _dateFormat.format(day),
    'Page': 1,
    'PageSize': _dayEventsPageSize,
  });

  Future<List<HomeNewsModel>> getLatestNews() async {
    final response = await _apiConsumer.get(
      EndPoints.news,
      queryParameters: {'Page': 1, 'PageSize': _newsPageSize},
    );
    return parseHomeItems(response).map(HomeNewsModel.fromJson).toList();
  }

  Future<List<HomeEventModel>> _events(String endpoint, Map<String, dynamic> query) async {
    final response = await _apiConsumer.get(endpoint, queryParameters: query);
    return parseHomeItems(response).map(HomeEventModel.fromJson).toList();
  }
}
