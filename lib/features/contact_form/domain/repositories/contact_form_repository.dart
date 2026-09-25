import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract interface class ContactFormRepository {
  Future<Either<Failure, void>> submitContactForm({
    required String fullName,
    required String email,
    required String subject,
    required String body,
  });
}
