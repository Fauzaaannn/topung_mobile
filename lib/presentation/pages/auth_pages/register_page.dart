import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/register_usecase.dart';
import 'package:topung_mobile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:topung_mobile/presentation/widgets/buttons/custom_button.dart';
import 'package:topung_mobile/presentation/widgets/text_fields/labeled_text_fields.dart';
import 'package:topung_mobile/presentation/widgets/text_fields/labeled_dropdown_field.dart';

@RoutePage()
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        loginUsecase: serviceLocator<LoginUsecase>(),
        registerUsecase: serviceLocator<RegisterUsecase>(),
        secureStorageService: serviceLocator<ISecureStorageService>(),
        sharedPreferences: serviceLocator<SharedPreferences>(),
      ),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        RegisterSubmitted(
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          usia: int.parse(_ageController.text),
          jenisKelamin: _selectedGender == 'Laki-laki' ? 'L' : 'P',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrasi berhasil! Silakan login.'),
              backgroundColor: Colors.green,
            ),
          );
          context.router.pop(); // Go back to login
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: FontConstant.fontSize32,
                      fontWeight: FontConstant.bold,
                      color: ColorConstant.black,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                  const SizedBox(height: 32),
                  LabeledTextField(
                    label: 'Nama',
                    placeholder: 'Masukkan Nama',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  LabeledTextField(
                    label: 'Usia',
                    placeholder: 'Masukkan usia',
                    controller: _ageController,
                    textFieldType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(3)],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Usia wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  LabeledDropdownField(
                    label: 'Jenis Kelamin',
                    placeholder: 'Pilih jenis kelamin',
                    value: _selectedGender,
                    items: const ['Laki-laki', 'Perempuan'],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Jenis kelamin wajib dipilih';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomButton(
                        label: 'Lanjutkan',
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
                        'Sudah punya akun? ',
                        style: TextStyle(
                          color: ColorConstant.grey,
                          fontSize: FontConstant.fontSize16,
                          fontFamily: FontConstant.robotoFontFamily,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.router.pop(),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            color: ColorConstant.greyDark,
                            fontSize: FontConstant.fontSize16,
                            fontWeight: FontConstant.semiBold,
                            fontFamily: FontConstant.robotoFontFamily,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
