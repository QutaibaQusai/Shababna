import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../models/event_details_model.dart';
import '../models/event_registration_model.dart';
import '../models/event_summary_model.dart';

class EventsRemoteDataSource {
  EventsRemoteDataSource(this._apiConsumer);

  static const _idempotencyKeyHeader = 'Idempotency-Key';

  final ApiConsumer _apiConsumer;

  Future<PagedResult<EventSummaryModel>> getEvents({
    required int page,
    required int pageSize,
  }) async {
    final response = await _apiConsumer.get(
      EndPoints.events,
      queryParameters: {'Page': page, 'PageSize': pageSize},
    );
    return PagedResult.fromJson(response as Map<String, dynamic>, EventSummaryModel.fromJson);
  }

  Future<EventDetailsModel> getEventById(String id) async {
    final response = await _apiConsumer.get(EndPoints.eventById(id));
    return EventDetailsModel.fromJson(response as Map<String, dynamic>);
  }

  Future<EventRegistrationModel> register(String id, {required String idempotencyKey}) async {
    final response = await _apiConsumer.post(
      EndPoints.eventRegister(id),
      headers: {_idempotencyKeyHeader: idempotencyKey},
    );
    return EventRegistrationModel.fromJson(response as Map<String, dynamic>);
  }

  Future<EventRegistrationModel> withdraw(String id) async {
    final response = await _apiConsumer.post(EndPoints.eventWithdraw(id));
    return EventRegistrationModel.fromJson(response as Map<String, dynamic>);
  }
}
