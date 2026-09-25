import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class SocialMediaLinks {
  const SocialMediaLinks({
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.threads,
    required this.snapchat,
    required this.linkedIn,
    required this.tikTok,
    required this.youTube,
  });

  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? threads;
  final String? snapchat;
  final String? linkedIn;
  final String? tikTok;
  final String? youTube;

  bool get hasAnyLink =>
      facebook != null ||
      twitter != null ||
      instagram != null ||
      threads != null ||
      snapchat != null ||
      linkedIn != null ||
      tikTok != null ||
      youTube != null;
}

abstract interface class SocialMediaRepository {
  Future<Either<Failure, SocialMediaLinks>> getSocialMediaLinks();
}
