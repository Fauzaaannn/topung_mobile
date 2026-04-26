import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:topung_mobile/data/provider/remote/implementation/auth_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/illness_category_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/illness_material_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/illness_type_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_auth_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_category_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_material_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_type_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/chatbot_history_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_history_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/chatbot_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/profile_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_profile_remote_provider.dart';

final serviceLocator = GetIt.instance;

void initializeProviderModule() {
  serviceLocator.registerLazySingleton<IAuthRemoteProvider>(
    () => AuthRemoteProvider(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IIllnessCategoryRemoteProvider>(
    () => IllnessCategoryRemoteProvider(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IIllnessTypeRemoteProvider>(
    () => IllnessTypeRemoteProvider(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IIllnessMaterialRemoteProvider>(
    () => IllnessMaterialRemoteProvider(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IChatbotHistoryRemoteProvider>(
    () => ChatbotHistoryRemoteProvider(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IChatbotRemoteProvider>(
    () => ChatbotRemoteProvider(serviceLocator<Dio>()),
  );
  
  serviceLocator.registerLazySingleton<IProfileRemoteProvider>(
    () => ProfileRemoteProvider(serviceLocator<Dio>()),
  );
}
