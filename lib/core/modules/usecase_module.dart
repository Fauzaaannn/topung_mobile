import 'package:get_it/get_it.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';
import 'package:topung_mobile/domain/repositories/illness_category_repository.dart';
import 'package:topung_mobile/domain/repositories/illness_type_repository.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:topung_mobile/domain/usecases/illness_category_usecases/illness_category_usecase.dart';
import 'package:topung_mobile/domain/usecases/illness_type_usecases/illness_type_usecase.dart';

final serviceLocator = GetIt.instance;

void initializeUsecaseModule() {
  serviceLocator.registerLazySingleton(
    () => LoginUsecase(serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => IllnessCategoryUsecase(serviceLocator<IllnessCategoryRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => IllnessTypeUsecase(serviceLocator<IllnessTypeRepository>()),
  );
}
