import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUsecase loginUsecase,
    required RegisterUsecase registerUsecase,
    required ISecureStorageService secureStorageService,
    required SharedPreferences sharedPreferences,
  }) : _loginUsecase = loginUsecase,
       _registerUsecase = registerUsecase,
       _secureStorageService = secureStorageService,
       _sharedPreferences = sharedPreferences,
       super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final LoginUsecase _loginUsecase;
  final RegisterUsecase _registerUsecase;
  final ISecureStorageService _secureStorageService;
  final SharedPreferences _sharedPreferences;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _loginUsecase(
      email: event.email,
      password: event.password,
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => '');
      emit(AuthFailure(message: failure));
    } else {
      final response = result.getOrElse(() => throw Exception());
      await _secureStorageService.saveToken(response.accessToken);
      await _secureStorageService.saveRole(response.user.role);
      emit(LoginSuccess(role: response.user.role));
    }
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _registerUsecase(
      username: event.username,
      email: event.email,
      password: event.password,
      usia: event.usia,
      jenisKelamin: event.jenisKelamin,
    );

    if (result.isLeft()) {
      final failure = result.fold((l) => l, (r) => '');
      emit(AuthFailure(message: failure));
    } else {
      emit(RegisterSuccess());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _secureStorageService.deleteAll();
    await _sharedPreferences.clear();
    emit(LogoutSuccess());
  }
}
