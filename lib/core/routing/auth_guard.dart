import 'package:auto_route/auto_route.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';

class AuthGuard extends AutoRouteGuard {
  final ISecureStorageService _secureStorage;

  AuthGuard(this._secureStorage);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final token = await _secureStorage.getToken();

    if (token == null || token.isEmpty) {
      resolver.next(false);
      router.replaceAll([const LoginRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
