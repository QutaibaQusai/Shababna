import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import 'volunteering_opportunity_types_state.dart';

class VolunteeringOpportunityTypesCubit extends Cubit<VolunteeringOpportunityTypesState> {
  VolunteeringOpportunityTypesCubit(this._repository)
    : super(const VolunteeringOpportunityTypesState());

  final VolunteeringOpportunitiesRepository _repository;

  Future<void> load() async {
    if (state.status == VolunteeringOpportunityTypesStatus.loading) return;
    if (state.types.isEmpty) {
      emit(
        const VolunteeringOpportunityTypesState(status: VolunteeringOpportunityTypesStatus.loading),
      );
    }

    final result = await _repository.getVolunteeringOpportunityTypes();
    if (isClosed) return;

    result.fold(
      (_) => emit(
        VolunteeringOpportunityTypesState(
          status: state.types.isEmpty
              ? VolunteeringOpportunityTypesStatus.failure
              : VolunteeringOpportunityTypesStatus.success,
          types: state.types,
        ),
      ),
      (types) => emit(
        VolunteeringOpportunityTypesState(
          status: VolunteeringOpportunityTypesStatus.success,
          types: types,
        ),
      ),
    );
  }
}
