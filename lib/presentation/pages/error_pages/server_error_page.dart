import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/presentation/widgets/buttons/custom_button.dart';
import 'package:topung_mobile/core/services/i_secure_storage_services.dart';
import 'package:topung_mobile/core/modules/app_module.dart';

@RoutePage()
class ServerErrorPage extends StatelessWidget {
  const ServerErrorPage({super.key});

  void _onBackToLogin(BuildContext context) async {
    final secureStorage = serviceLocator<ISecureStorageService>();
    await secureStorage.deleteAll();
    if (context.mounted) {
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('asset/maintenance.svg', height: 250),
                const SizedBox(height: 32),
                Text(
                  'Server Sedang Gangguan',
                  style: TextStyle(
                    fontSize: FontConstant.fontSize24,
                    fontWeight: FontConstant.bold,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Mohon maaf, saat ini server sedang mengalami gangguan atau dalam perbaikan. Silakan coba beberapa saat lagi.',
                  style: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    color: ColorConstant.greyDark,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomButton(
                  label: 'Kembali ke Login',
                  width: double.infinity,
                  onPressed: () => _onBackToLogin(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
