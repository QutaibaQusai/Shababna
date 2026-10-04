import '../../../../core/config/app_config.dart';
import '../../domain/repositories/events_repository.dart';
import '../models/event_details_model.dart';
import '../models/event_json_parsing.dart';
import '../models/event_registration_model.dart';
import '../models/event_summary_model.dart';
import '../models/event_type_model.dart';

extension EventSummaryModelMapper on EventSummaryModel {
  EventSummary toEntity() {
    return EventSummary(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      type: eventType.toEntity(),
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
    );
  }
}

extension EventDetailsModelMapper on EventDetailsModel {
  EventDetails toEntity() {
    return EventDetails(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      type: eventType.toEntity(),
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
            (donor) => EventDonor(
              id: donor.id,
              title: donor.title,
              imageUrl: _toAbsoluteUrl(donor.imageUrl),
            ),
          )
          .toList(),
      images: images
          .where((image) => image.url.isNotEmpty)
          .map((image) => EventImage(id: image.id, url: _toAbsoluteUrl(image.url)))
          .toList(),
    );
  }
}

extension EventRegistrationModelMapper on EventRegistrationModel {
  EventRegistrationResult toEntity() {
    return EventRegistrationResult(
      registrationStatus: _registrationStatus(registrationStatus),
      message: message,
    );
  }
}

extension EventTypeModelsMapper on List<EventTypeModel> {
  List<EventType> toEntities() {
    final active = where((type) => type.isActive && type.id.isNotEmpty).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return active
        .map(
          (type) => EventType(
            id: type.id,
            nameEn: type.nameEn,
            nameAr: type.nameAr,
            eventsCount: type.eventsCount,
          ),
        )
        .toList();
  }
}

extension on EventReferenceModel {
  EventReference toEntity() => EventReference(id: id, name: name);
}

EventGender _gender(String value) => switch (value) {
  'Male' => EventGender.male,
  'Female' => EventGender.female,
  _ => EventGender.both,
};

EventRegistrationStatus _registrationStatus(String value) => switch (value) {
  'PendingApproval' => EventRegistrationStatus.pendingApproval,
  'Approved' => EventRegistrationStatus.approved,
  'Withdrawn' => EventRegistrationStatus.withdrawn,
  'Rejected' => EventRegistrationStatus.rejected,
  _ => EventRegistrationStatus.notRegistered,
};

String _toAbsoluteUrl(String path) {
  if (path.isEmpty || path.startsWith('http')) return path;
  return '${AppConfig.baseUrl}$path';
}
