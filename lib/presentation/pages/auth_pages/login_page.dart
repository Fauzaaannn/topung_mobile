import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:topung_mobile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:topung_mobile/presentation/widgets/buttons/custom_button.dart';
import 'package:topung_mobile/presentation/widgets/text_fields/labeled_text_fields.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: serviceLocator<LoginUsecase>(),
        secureStorageService: serviceLocator<ISecureStorageService>(),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onCreateAccount() {
    context.router.push(const RegisterRoute());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.router.replaceAll([const NavbarRoute()]);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: FontConstant.fontSize32,
                      fontWeight: FontConstant.bold,
                      color: ColorConstant.black,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                  const SizedBox(height: 60),
                  LabeledTextField(
                    label: 'Email',
                    placeholder: 'Masukkan email',
                    controller: _emailController,
                    textFieldType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: 'Password',
                    placeholder: 'Masukkan password',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (value.length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: 'Continue',
                        width: double.infinity,
                        onPressed: state is AuthLoading ? () {} : _onContinue,
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: ColorConstant.grey,
                          fontSize: FontConstant.fontSize14,
                          fontFamily: FontConstant.robotoFontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: _onCreateAccount,
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: ColorConstant.greyDark,
                            fontSize: FontConstant.fontSize14,
                            fontWeight: FontConstant.semiBold,
                            fontFamily: FontConstant.robotoFontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
