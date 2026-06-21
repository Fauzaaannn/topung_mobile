import 'package:auto_route/auto_route.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/core/routing/auth_guard.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    final authGuard = AuthGuard(serviceLocator<ISecureStorageService>());
    
    return [
      AutoRoute(page: SplashRoute.page, initial: true),
      AutoRoute(page: LoginRoute.page),
      AutoRoute(page: RegisterRoute.page),
      AutoRoute(
        page: NavbarRoute.page,
        guards: [authGuard],
        children: [
          AutoRoute(page: IllnessCategoryRoute.page, initial: true),
          AutoRoute(page: ChatHistoryRoute.page),
          AutoRoute(page: ProfileRoute.page),
        ],
      ),
      AutoRoute(page: IllnessTypeRoute.page, guards: [authGuard]),
      AutoRoute(page: IllnessMaterialRoute.page, guards: [authGuard]),
      AutoRoute(page: ChatRoute.page, guards: [authGuard]),
      AutoRoute(page: ServerErrorRoute.page),
    ];
  }
}
