import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUsecase loginUsecase,
    required ISecureStorageService secureStorageService,
  }) : _loginUsecase = loginUsecase,
       _secureStorageService = secureStorageService,
       super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final LoginUsecase _loginUsecase;
  final ISecureStorageService _secureStorageService;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUsecase(
      email: event.email,
      password: event.password,
    );

    result.fold((failure) => emit(AuthFailure(message: failure)), (
      response,
    ) async {
      await _secureStorageService.saveToken(response.accessToken);
      await _secureStorageService.saveRole(response.user.role);
      emit(LoginSuccess(role: response.user.role));
    });
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _secureStorageService.deleteAll();
    emit(LogoutSuccess());
  }
}
