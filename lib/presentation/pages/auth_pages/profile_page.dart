import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/presentation/widgets/buttons/custom_button.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                          onPressed: () {
                            context.router.popUntilRoot();
                          },
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
