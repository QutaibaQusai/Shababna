import '../../../../core/config/app_config.dart';
import '../../domain/repositories/volunteering_opportunities_repository.dart';
import '../models/volunteering_opportunity_details_model.dart';
import '../models/volunteering_opportunity_json_parsing.dart';
import '../models/volunteering_opportunity_registration_model.dart';
import '../models/volunteering_opportunity_summary_model.dart';
import '../models/volunteering_opportunity_type_model.dart';

extension VolunteeringOpportunitySummaryModelMapper on VolunteeringOpportunitySummaryModel {
  VolunteeringOpportunitySummary toEntity() {
    return VolunteeringOpportunitySummary(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      type: volunteeringOpportunityType.toEntity(),
      from: DateTime.parse(from),
      to: DateTime.parse(to),
      address: address,
      gender: _gender(gender),
      ageFrom: ageFrom,
      ageTo: ageTo,
      hours: hours,
      volunteersCount: volunteersCount,
      requiresApproval: requiresApproval,
      imageUrl: _toAbsoluteUrl(imageUrl),
      hasEnded: hasEnded,
    );
  }
}

extension VolunteeringOpportunityDetailsModelMapper on VolunteeringOpportunityDetailsModel {
  VolunteeringOpportunityDetails toEntity() {
    return VolunteeringOpportunityDetails(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      type: volunteeringOpportunityType.toEntity(),
      from: DateTime.parse(from),
      to: DateTime.parse(to),
      address: address,
      gender: _gender(gender),
      ageFrom: ageFrom,
      ageTo: ageTo,
      hours: hours,
      activitiesCount: activitiesCount,
      volunteersCount: volunteersCount,
      requiresApproval: requiresApproval,
      nationalities: nationalities.map((item) => item.toEntity()).toList(),
      cities: cities.map((item) => item.toEntity()).toList(),
      educations: educations.map((item) => item.toEntity()).toList(),
      imageUrl: _toAbsoluteUrl(imageUrl),
      registrationStatus: _registrationStatus(registrationStatus),
      donors: donors
          .map(
            (donor) => VolunteeringOpportunityDonor(
              id: donor.id,
              title: donor.title,
              imageUrl: _toAbsoluteUrl(donor.imageUrl),
            ),
          )
          .toList(),
      images: images
          .where((image) => image.url.isNotEmpty)
          .map(
            (image) => VolunteeringOpportunityImage(id: image.id, url: _toAbsoluteUrl(image.url)),
          )
          .toList(),
      properties: properties
          .map(
            (property) => VolunteeringOpportunityProperty(
              labelEn: property.labelEn,
              labelAr: property.labelAr,
              valueEn: property.valueEn,
              valueAr: property.valueAr,
            ),
          )
          .where((property) => property.isComplete)
          .toList(),
      hasEnded: hasEnded,
    );
  }
}

extension VolunteeringOpportunityRegistrationModelMapper
    on VolunteeringOpportunityRegistrationModel {
  VolunteeringOpportunityRegistrationResult toEntity() {
    return VolunteeringOpportunityRegistrationResult(
      registrationStatus: _registrationStatus(registrationStatus),
      message: message,
    );
  }
}

extension VolunteeringOpportunityTypeModelsMapper on List<VolunteeringOpportunityTypeModel> {
  List<VolunteeringOpportunityType> toEntities() {
    final active = where((type) => type.isActive && type.id.isNotEmpty).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return active
        .map(
          (type) => VolunteeringOpportunityType(
            id: type.id,
            nameEn: type.nameEn,
            nameAr: type.nameAr,
            volunteeringOpportunitiesCount: type.volunteeringOpportunitiesCount,
          ),
        )
        .toList();
  }
}

extension on VolunteeringOpportunityReferenceModel {
  VolunteeringOpportunityReference toEntity() =>
      VolunteeringOpportunityReference(id: id, name: name);
}

VolunteeringOpportunityGender _gender(String value) => switch (value) {
  'Male' => VolunteeringOpportunityGender.male,
  'Female' => VolunteeringOpportunityGender.female,
  _ => VolunteeringOpportunityGender.both,
};

VolunteeringOpportunityRegistrationStatus _registrationStatus(String value) => switch (value) {
  'PendingApproval' => VolunteeringOpportunityRegistrationStatus.pendingApproval,
  'Approved' => VolunteeringOpportunityRegistrationStatus.approved,
  'Withdrawn' => VolunteeringOpportunityRegistrationStatus.withdrawn,
  'Rejected' => VolunteeringOpportunityRegistrationStatus.rejected,
  _ => VolunteeringOpportunityRegistrationStatus.notRegistered,
};

String _toAbsoluteUrl(String path) {
  if (path.isEmpty || path.startsWith('http')) return path;
  return '${AppConfig.baseUrl}$path';
}
