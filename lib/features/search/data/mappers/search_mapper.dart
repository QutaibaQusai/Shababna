import '../../../../core/config/app_config.dart';
import '../../domain/repositories/search_repository.dart';
import '../models/global_search_response_model.dart';

extension GlobalSearchResponseModelMapper on GlobalSearchResponseModel {
  GlobalSearchResults toEntity() {
    return GlobalSearchResults(
      volunteeringOpportunities: _group(volunteeringOpportunities, (item) => item.toEntity()),
      news: _group(news, (item) => item.toEntity()),
      faq: _group(faq, (item) => item.toEntity()),
    );
  }
}

extension on SearchVolunteeringOpportunityItemModel {
  SearchVolunteeringOpportunityResult toEntity() {
    return SearchVolunteeringOpportunityResult(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      typeNameEn: volunteeringOpportunityTypeNameEn,
      typeNameAr: volunteeringOpportunityTypeNameAr,
      from: DateTime.parse(from),
      to: DateTime.parse(to),
      timeline: switch (status) {
        'Ongoing' => SearchVolunteeringOpportunityTimeline.ongoing,
        'Past' => SearchVolunteeringOpportunityTimeline.past,
        _ => SearchVolunteeringOpportunityTimeline.upcoming,
      },
      imageUrl: _toAbsoluteUrl(imageUrl),
    );
  }
}

extension on SearchNewsItemModel {
  SearchNewsResult toEntity() {
    return SearchNewsResult(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      date: DateTime.parse(date),
      imageUrl: _toAbsoluteUrl(imageUrl),
    );
  }
}

extension on SearchFaqItemModel {
  SearchFaqResult toEntity() {
    return SearchFaqResult(
      id: id,
      topicId: chatbotId,
      topicNameEn: chatbotNameEn,
      topicNameAr: chatbotNameAr,
      questionEn: questionEn,
      questionAr: questionAr,
    );
  }
}

SearchGroup<E> _group<M, E>(SearchGroupModel<M> model, E Function(M item) toEntity) {
  return SearchGroup(items: model.items.map(toEntity).toList(), hasMore: model.hasMore);
}

String _toAbsoluteUrl(String path) {
  if (path.isEmpty || path.startsWith('http')) return path;
  return '${AppConfig.baseUrl}$path';
}
