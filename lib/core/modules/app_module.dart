import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/core/modules/provider_module.dart';
import 'package:topung_mobile/core/modules/repository_module.dart';
import 'package:topung_mobile/core/modules/service_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/core/services/secure_storage_services.dart';
import 'package:topung_mobile/core/utils/interceptor/api_interceptor.dart';
import 'package:topung_mobile/core/utils/logger/debug_log_interceptor.dart';

final serviceLocator = GetIt.instance;

Future<void> _initializeExternalDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerLazySingleton<ISecureStorageService>(
    () => SecureStorageService(),
  );

  serviceLocator.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EndpointConstant.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      ApiInterceptor(serviceLocator<ISecureStorageService>() as SecureStorageService),
      DebugLogInterceptor(),
    ]);

    return dio;
  });

  serviceLocator.registerLazySingleton<AppRouter>(() => AppRouter());
}

Future<void> initializeAllModules() async {
  await _initializeExternalDependencies();
  initializeServiceModule();
  initializeProviderModule();
  initializeRepositoryModule();
}