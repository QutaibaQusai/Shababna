import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/contact_form_repository.dart';
import '../datasources/contact_form_remote_data_source.dart';
import '../models/contact_form_request_model.dart';

class ContactFormRepositoryImpl with RepositoryGuardMixin implements ContactFormRepository {
  ContactFormRepositoryImpl(this._remoteDataSource);

  final ContactFormRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> submitContactForm({
    required String fullName,
    required String email,
    required String subject,
    required String body,
  }) {
    return guard(() {
      return _remoteDataSource.submitContactForm(
        ContactFormRequestModel(fullName: fullName, email: email, subject: subject, body: body),
      );
    });
  }
}
