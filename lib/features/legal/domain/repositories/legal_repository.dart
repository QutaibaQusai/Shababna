import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class LegalContent {
  const LegalContent({
    required this.privacyPolicyEn,
    required this.privacyPolicyAr,
    required this.termsAndConditionsEn,
    required this.termsAndConditionsAr,
  });

  final String privacyPolicyEn;
  final String privacyPolicyAr;
  final String termsAndConditionsEn;
  final String termsAndConditionsAr;
}

abstract interface class LegalRepository {
  Future<Either<Failure, LegalContent>> getContent();
}
