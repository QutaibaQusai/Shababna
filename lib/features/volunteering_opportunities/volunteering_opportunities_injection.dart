import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/volunteering_opportunities_remote_data_source.dart';
import 'data/repositories/volunteering_opportunities_repository_impl.dart';
import 'domain/repositories/volunteering_opportunities_repository.dart';
import 'presentation/cubit/volunteering_opportunity_details/volunteering_opportunity_details_cubit.dart';
import 'presentation/cubit/volunteering_opportunities_date_filter/volunteering_opportunities_date_filter_cubit.dart';
import 'presentation/cubit/volunteering_opportunity_types/volunteering_opportunity_types_cubit.dart';
import 'presentation/cubit/volunteering_opportunities_list/volunteering_opportunities_list_cubit.dart';

void registerVolunteeringOpportunitiesFeature(GetIt sl) {
  sl.registerLazySingleton<VolunteeringOpportunitiesRemoteDataSource>(
    () => VolunteeringOpportunitiesRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<VolunteeringOpportunitiesRepository>(
    () => VolunteeringOpportunitiesRepositoryImpl(sl<VolunteeringOpportunitiesRemoteDataSource>()),
  );

  sl.registerLazySingleton<VolunteeringOpportunitiesDateFilterCubit>(
    VolunteeringOpportunitiesDateFilterCubit.new,
  );

  sl.registerFactory<VolunteeringOpportunitiesListCubit>(
    () => VolunteeringOpportunitiesListCubit(
      sl<VolunteeringOpportunitiesRepository>(),
      initialDate: sl<VolunteeringOpportunitiesDateFilterCubit>().state,
    ),
  );

  sl.registerFactory<VolunteeringOpportunityTypesCubit>(
    () => VolunteeringOpportunityTypesCubit(sl<VolunteeringOpportunitiesRepository>()),
  );

  sl.registerFactoryParam<VolunteeringOpportunityDetailsCubit, String, void>(
    (id, _) =>
        VolunteeringOpportunityDetailsCubit(sl<VolunteeringOpportunitiesRepository>(), id: id),
  );
}
