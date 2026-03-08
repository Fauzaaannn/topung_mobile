import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/presentation/widgets/buttons/custom_button.dart';
import 'package:topung_mobile/presentation/widgets/text_fields/labeled_text_fields.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: lanjutkan ke proses register
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: FontConstant.fontSize32,
                    fontWeight: FontConstant.bold,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                ),
                const SizedBox(height: 32),
                LabeledTextField(
                  label: 'Nama Lengkap',
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Usia wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: 'Jenis Kelamin',
                  placeholder: 'Pilih jenis kelamin',
                  controller: _genderController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Jenis kelamin wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Continue',
                  width: double.infinity,
                  onPressed: _onContinue,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: ColorConstant.grey,
                        fontSize: FontConstant.fontSize14,
                        fontFamily: FontConstant.robotoFontFamily,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.router.pop(),
                      child: Text(
                        'Sign In',
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
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
