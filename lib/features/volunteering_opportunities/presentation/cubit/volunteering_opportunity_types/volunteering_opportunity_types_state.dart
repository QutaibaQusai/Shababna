import 'package:equatable/equatable.dart';

import '../../../domain/repositories/volunteering_opportunities_repository.dart';

enum VolunteeringOpportunityTypesStatus { initial, loading, success, failure }

class VolunteeringOpportunityTypesState extends Equatable {
  const VolunteeringOpportunityTypesState({
    this.status = VolunteeringOpportunityTypesStatus.initial,
    this.types = const [],
  });

  final VolunteeringOpportunityTypesStatus status;
  final List<VolunteeringOpportunityType> types;

  List<VolunteeringOpportunityType> get visibleTypes =>
      types.where((type) => type.hasVolunteeringOpportunities).toList();

  bool get isLoading =>
      status == VolunteeringOpportunityTypesStatus.initial ||
      status == VolunteeringOpportunityTypesStatus.loading;

  @override
  List<Object?> get props => [status, types];
}
