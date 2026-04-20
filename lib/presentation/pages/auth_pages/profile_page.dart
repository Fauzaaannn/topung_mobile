import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/domain/usecases/auth_usecases/login_usecase.dart';
import 'package:topung_mobile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:topung_mobile/presentation/widgets/buttons/custom_button.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text(
              'Ya, Logout',
              style: TextStyle(color: ColorConstant.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        loginUsecase: serviceLocator<LoginUsecase>(),
        secureStorageService: serviceLocator<ISecureStorageService>(),
        sharedPreferences: serviceLocator<SharedPreferences>(),
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            context.router.replaceAll([const LoginRoute()]);
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: ColorConstant.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: ColorConstant.primary,
                elevation: 0,
                title: Text(
                  'Profil',
                  style: TextStyle(
                    fontSize: FontConstant.fontSize18,
                    fontWeight: FontConstant.bold,
                    color: ColorConstant.white,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileField('Nama', 'Tralalelo Tralala'),
                            const SizedBox(height: 20),
                            _buildProfileField('Email', 'tralelo@gmail.com'),
                            const SizedBox(height: 20),
                            _buildProfileField('Usia', '40'),
                            const SizedBox(height: 20),
                            _buildProfileField(
                              'Jenis Kelamin',
                              'Laki-laki / Perempuan',
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  label: 'Logout',
                                  height: 40,
                                  borderRadius: 20,
                                  backgroundColor: ColorConstant.error,
                                  onPressed: () => _showLogoutDialog(context),
                                ),
                                CustomButton(
                                  label: 'Edit',
                                  height: 40,
                                  borderRadius: 20,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontConstant.fontSize14,
            color: Colors.grey,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: FontConstant.fontSize16,
            fontWeight: FontConstant.bold,
            color: ColorConstant.black,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
      ],
    );
  }
}
