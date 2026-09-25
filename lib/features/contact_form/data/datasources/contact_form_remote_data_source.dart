import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../models/contact_form_request_model.dart';

class ContactFormRemoteDataSource {
  ContactFormRemoteDataSource(this._apiConsumer);

  final ApiConsumer _apiConsumer;

  Future<void> submitContactForm(ContactFormRequestModel request) {
    return _apiConsumer.post(EndPoints.contactForms, data: request.toJson());
  }
}
