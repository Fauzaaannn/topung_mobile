import 'package:get_it/get_it.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_auth_remote_provider.dart';
import 'package:topung_mobile/data/repositories/auth_repository_impl.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';

final serviceLocator = GetIt.instance;

void initializeRepositoryModule() {
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator<IAuthRemoteProvider>()),
  );
}
