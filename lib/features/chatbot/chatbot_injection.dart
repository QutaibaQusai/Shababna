import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/chatbot_remote_data_source.dart';
import 'data/repositories/chatbot_repository_impl.dart';
import 'domain/repositories/chatbot_repository.dart';
import 'domain/services/faq_answer_finder.dart';
import 'presentation/cubit/chatbot_cubit.dart';

void registerChatbotFeature(GetIt sl) {
  sl.registerLazySingleton<ChatbotRemoteDataSource>(
    () => ChatbotRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(sl<ChatbotRemoteDataSource>()),
  );

  sl.registerLazySingleton<FaqAnswerFinder>(() => FaqAnswerFinder(sl<ChatbotRepository>()));

  sl.registerFactory<ChatbotCubit>(
    () => ChatbotCubit(sl<ChatbotRepository>(), sl<FaqAnswerFinder>()),
  );
}
