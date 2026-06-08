import 'package:dio/dio.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/core/services/secure_storage_services.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _secureStorageService.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Content-Type'] = 'application/json';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _secureStorageService.deleteAll();
      serviceLocator<AppRouter>().replaceAll([const LoginRoute()]);
    }

    return handler.next(err);
  }
}
