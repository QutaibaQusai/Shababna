import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/city_model.dart';
import '../models/country_model.dart';
import '../models/education_model.dart';
import '../models/phone_code_model.dart';
import '../models/volunteering_type_model.dart';

class ProfileLookupsRemoteDataSource {
  ProfileLookupsRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<List<CountryModel>> getCountries() async {
    final items = await _fetchAllPages(EndPoints.countries);
    return items.map((item) => CountryModel.fromJson(item)).toList();
  }

  Future<List<CityModel>> getCities() async {
    final items = await _fetchAllPages(EndPoints.cities);
    return items.map((item) => CityModel.fromJson(item)).toList();
  }

  Future<List<EducationModel>> getEducations() async {
    final items = await _fetchAllPages(EndPoints.educations);
    return items.map((item) => EducationModel.fromJson(item)).toList();
  }

  Future<List<VolunteeringTypeModel>> getVolunteeringTypes() async {
    final items = await _fetchAllPages(EndPoints.volunteeringTypes);
    return items.map((item) => VolunteeringTypeModel.fromJson(item)).toList();
  }

  Future<List<PhoneCodeModel>> getPhoneCodes() async {
    final response = await _apiConsumer.get(EndPoints.countryPhoneCodes) as List;
    return response
        .map((item) => PhoneCodeModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Map<String, dynamic>>> _fetchAllPages(String path) async {
    final allItems = <Map<String, dynamic>>[];
    var page = 1;

    while (true) {
      final response = await _apiConsumer.get(
        path,
        queryParameters: {'Page': page, 'PageSize': 100},
      ) as Map<String, dynamic>;

      allItems.addAll((response['items'] as List).cast<Map<String, dynamic>>());

      if (response['hasNextPage'] != true) break;
      page++;
    }

    return allItems;
  }
}
