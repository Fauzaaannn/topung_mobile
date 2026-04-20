import 'package:auto_route/auto_route.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(
      page: NavbarRoute.page,
      children: [
        AutoRoute(page: IllnessCategoryRoute.page, initial: true),
        AutoRoute(page: ChatHistoryRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: IllnessTypeRoute.page),
    AutoRoute(page: IllnessMaterialRoute.page),
    AutoRoute(page: ChatRoute.page),
  ];
}
