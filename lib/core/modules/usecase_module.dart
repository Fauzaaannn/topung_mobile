import 'package:get_it/get_it.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';

final serviceLocator = GetIt.instance;

void initializeUsecaseModule() {
  serviceLocator.registerLazySingleton(
    () => LoginUsecase(serviceLocator<AuthRepository>()),
  );
}
