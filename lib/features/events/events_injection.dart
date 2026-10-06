import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/events_remote_data_source.dart';
import 'data/repositories/events_repository_impl.dart';
import 'domain/repositories/events_repository.dart';
import 'presentation/cubit/event_details/event_details_cubit.dart';
import 'presentation/cubit/events_date_filter/events_date_filter_cubit.dart';
import 'presentation/cubit/event_types/event_types_cubit.dart';
import 'presentation/cubit/events_list/events_list_cubit.dart';

void registerEventsFeature(GetIt sl) {
  sl.registerLazySingleton<EventsRemoteDataSource>(() => EventsRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<EventsRepository>(
    () => EventsRepositoryImpl(sl<EventsRemoteDataSource>()),
  );

  sl.registerLazySingleton<EventsDateFilterCubit>(EventsDateFilterCubit.new);

  sl.registerFactory<EventsListCubit>(
    () => EventsListCubit(sl<EventsRepository>(), initialDate: sl<EventsDateFilterCubit>().state),
  );

  sl.registerFactory<EventTypesCubit>(() => EventTypesCubit(sl<EventsRepository>()));

  sl.registerFactoryParam<EventDetailsCubit, String, void>(
    (id, _) => EventDetailsCubit(sl<EventsRepository>(), id: id),
  );
}
