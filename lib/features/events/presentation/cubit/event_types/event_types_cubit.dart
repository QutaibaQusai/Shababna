import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/events_repository.dart';
import 'event_types_state.dart';

class EventTypesCubit extends Cubit<EventTypesState> {
  EventTypesCubit(this._repository) : super(const EventTypesState());

  final EventsRepository _repository;

  Future<void> load() async {
    if (state.status == EventTypesStatus.loading) return;
    if (state.types.isEmpty) {
      emit(const EventTypesState(status: EventTypesStatus.loading));
    }

    final result = await _repository.getEventTypes();
    if (isClosed) return;

    result.fold(
      (_) => emit(
        EventTypesState(
          status: state.types.isEmpty ? EventTypesStatus.failure : EventTypesStatus.success,
          types: state.types,
        ),
      ),
      (types) => emit(EventTypesState(status: EventTypesStatus.success, types: types)),
    );
  }
}
