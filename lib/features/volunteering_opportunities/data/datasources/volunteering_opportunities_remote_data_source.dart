import 'package:intl/intl.dart';

import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../models/volunteering_opportunity_details_model.dart';
import '../models/volunteering_opportunity_json_parsing.dart';
import '../models/volunteering_opportunity_registration_model.dart';
import '../models/volunteering_opportunity_summary_model.dart';
import '../models/volunteering_opportunity_type_model.dart';

class VolunteeringOpportunitiesRemoteDataSource {
  VolunteeringOpportunitiesRemoteDataSource(this._apiConsumer);

  static const _idempotencyKeyHeader = 'Idempotency-Key';
  static const _volunteeringOpportunityTypesPageSize = 100;
  static final _dateFormat = DateFormat('yyyy-MM-dd');

  final ApiConsumer _apiConsumer;

  Future<PagedResult<VolunteeringOpportunitySummaryModel>> getVolunteeringOpportunities({
    required int page,
    required int pageSize,
    String? typeId,
    DateTime? date,
  }) async {
    final response = await _apiConsumer.get(
      date == null
          ? EndPoints.volunteeringOpportunities
          : EndPoints.volunteeringOpportunitiesByDate,
      queryParameters: {
        'Page': page,
        'PageSize': pageSize,
        'EventTypeId': ?typeId,
        if (date != null) 'Date': _dateFormat.format(date),
      },
    );
    return PagedResult.fromJson(
      response as Map<String, dynamic>,
      VolunteeringOpportunitySummaryModel.fromJson,
    );
  }

  Future<List<VolunteeringOpportunityTypeModel>> getVolunteeringOpportunityTypes() async {
    final response = await _apiConsumer.get(
      EndPoints.volunteeringOpportunityTypes,
      queryParameters: {'Page': 1, 'PageSize': _volunteeringOpportunityTypesPageSize},
    );
    final json = response as Map<String, dynamic>;
    return parseVolunteeringOpportunityList(
      json['items'],
      VolunteeringOpportunityTypeModel.fromJson,
    );
  }

  Future<VolunteeringOpportunityDetailsModel> getVolunteeringOpportunityById(String id) async {
    final response = await _apiConsumer.get(EndPoints.volunteeringOpportunityById(id));
    return VolunteeringOpportunityDetailsModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VolunteeringOpportunityRegistrationModel> register(
    String id, {
    required String idempotencyKey,
  }) async {
    final response = await _apiConsumer.post(
      EndPoints.volunteeringOpportunityRegister(id),
      headers: {_idempotencyKeyHeader: idempotencyKey},
    );
    return VolunteeringOpportunityRegistrationModel.fromJson(response as Map<String, dynamic>);
  }

  Future<VolunteeringOpportunityRegistrationModel> withdraw(String id) async {
    final response = await _apiConsumer.post(EndPoints.volunteeringOpportunityWithdraw(id));
    return VolunteeringOpportunityRegistrationModel.fromJson(response as Map<String, dynamic>);
  }
}
