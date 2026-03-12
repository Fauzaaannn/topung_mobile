import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:topung_mobile/data/provider/remote/implementation/auth_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/implementation/illness_category_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_auth_remote_provider.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_category_remote_provider.dart';

final serviceLocator = GetIt.instance;

void initializeProviderModule() {
  serviceLocator.registerLazySingleton<IAuthRemoteProvider>(
    () => AuthRemoteProvider(serviceLocator<Dio>()),
  );

  serviceLocator.registerLazySingleton<IIllnessCategoryRemoteProvider>(
    () => IllnessCategoryRemoteProvider(serviceLocator<Dio>()),
  );
}
