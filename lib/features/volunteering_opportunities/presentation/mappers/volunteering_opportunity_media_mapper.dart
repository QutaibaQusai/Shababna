import '../../../../core/shared/views/media_viewer/app_media.dart';
import '../../domain/repositories/volunteering_opportunities_repository.dart';

extension VolunteeringOpportunityMediaMapper on VolunteeringOpportunityDetails {
  List<AppMedia> get media => [
    if (imageUrl.isNotEmpty) AppImageMedia(imageUrl),
    ...images.map((image) => AppImageMedia(image.url)),
  ];
}
