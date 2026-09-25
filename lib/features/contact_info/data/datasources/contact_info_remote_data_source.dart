import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/contact_info_model.dart';

class ContactInfoRemoteDataSource {
  ContactInfoRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<ContactInfoModel> getContactInfo() async {
    final response = await _apiConsumer.get(EndPoints.contactInformation);
    return ContactInfoModel.fromJson(response as Map<String, dynamic>);
  }
}
