import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AboutUsContent {
  const AboutUsContent({
    required this.aboutUsEn,
    required this.aboutUsAr,
  });

  final String aboutUsEn;
  final String aboutUsAr;
}

abstract interface class AboutUsRepository {
  Future<Either<Failure, AboutUsContent>> getAboutUs();
}
