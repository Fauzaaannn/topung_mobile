import 'package:get_it/get_it.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_auth_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_category_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_material_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_type_remote_provider.dart';
import 'package:topung_mobile/data/repositories/auth_repository_impl.dart';
import 'package:topung_mobile/data/repositories/illness_category_repository_impl.dart';
import 'package:topung_mobile/data/repositories/illness_material_repository_impl.dart';
import 'package:topung_mobile/data/repositories/illness_type_repository_impl.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';
import 'package:topung_mobile/domain/repositories/illness_category_repository.dart';
import 'package:topung_mobile/domain/repositories/illness_material_repository.dart';
import 'package:topung_mobile/domain/repositories/illness_type_repository.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_history_remote_provider.dart';
import 'package:topung_mobile/data/repositories/chatbot_history_repository_impl.dart';
import 'package:topung_mobile/domain/repositories/chatbot_history_repository.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_remote_provider.dart';
import 'package:topung_mobile/data/repositories/chatbot_repository_impl.dart';
import 'package:topung_mobile/domain/repositories/chatbot_repository.dart';
final serviceLocator = GetIt.instance;

void initializeRepositoryModule() {
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator<IAuthRemoteProvider>()),
  );

  serviceLocator.registerLazySingleton<IllnessCategoryRepository>(
    () => IllnessCategoryRepositoryImpl(
      serviceLocator<IIllnessCategoryRemoteProvider>(),
    ),
  );

  serviceLocator.registerLazySingleton<IllnessTypeRepository>(
    () =>
        IllnessTypeRepositoryImpl(serviceLocator<IIllnessTypeRemoteProvider>()),
  );

  serviceLocator.registerLazySingleton<IllnessMaterialRepository>(
    () => IllnessMaterialRepositoryImpl(
      serviceLocator<IIllnessMaterialRemoteProvider>(),
    ),
  );

  serviceLocator.registerLazySingleton<ChatbotHistoryRepository>(
    () => ChatbotHistoryRepositoryImpl(
      serviceLocator<IChatbotHistoryRemoteProvider>(),
    ),
  );

  serviceLocator.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      serviceLocator<IChatbotRemoteProvider>(),
    ),
  );
}
