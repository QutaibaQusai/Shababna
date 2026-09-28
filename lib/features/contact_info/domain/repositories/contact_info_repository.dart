import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class ContactInfo {
  const ContactInfo({
    required this.email,
    required this.complaintsEmail,
    required this.phoneNumber,
    required this.complaintsPhoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.googleMapsUrl,
  });

  final String email;
  final String complaintsEmail;
  final String phoneNumber;
  final String complaintsPhoneNumber;
  final String address;
  final double latitude;
  final double longitude;
  final String googleMapsUrl;
}

abstract interface class ContactInfoRepository {
  Future<Either<Failure, ContactInfo>> getContactInfo();
}
