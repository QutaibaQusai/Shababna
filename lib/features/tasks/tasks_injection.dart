import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/tasks_remote_data_source.dart';
import 'data/repositories/tasks_repository_impl.dart';
import 'domain/repositories/tasks_repository.dart';
import 'presentation/cubit/task_details/task_details_cubit.dart';
import 'presentation/cubit/task_submission/task_submission_cubit.dart';
import 'presentation/cubit/tasks_list/tasks_list_cubit.dart';

void registerTasksFeature(GetIt sl) {
  sl.registerLazySingleton<TasksRemoteDataSource>(() => TasksRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(sl<TasksRemoteDataSource>()));

  sl.registerFactoryParam<TasksListCubit, String?, void>(
    (volunteeringOpportunityId, _) =>
        TasksListCubit(sl<TasksRepository>(), volunteeringOpportunityId: volunteeringOpportunityId),
  );

  sl.registerFactoryParam<TaskDetailsCubit, String, void>(
    (id, _) => TaskDetailsCubit(sl<TasksRepository>(), id: id),
  );

  sl.registerFactoryParam<TaskSubmissionCubit, String, void>(
    (taskId, _) => TaskSubmissionCubit(sl<TasksRepository>(), taskId: taskId),
  );
}
