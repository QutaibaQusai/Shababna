import 'package:equatable/equatable.dart';

import '../../../domain/repositories/events_repository.dart';

enum EventTypesStatus { initial, loading, success, failure }

class EventTypesState extends Equatable {
  const EventTypesState({this.status = EventTypesStatus.initial, this.types = const []});

  final EventTypesStatus status;
  final List<EventType> types;

  List<EventType> get visibleTypes => types.where((type) => type.hasEvents).toList();

  bool get isLoading => status == EventTypesStatus.initial || status == EventTypesStatus.loading;

  @override
  List<Object?> get props => [status, types];
}
