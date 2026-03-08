// filepath: lib/presentation/widgets/buttons/custom_button.dart
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final FontWeight fontWeight;
  final double fontSize;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.fontWeight = FontWeight.w600,
    this.fontSize = FontConstant.fontSize16,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 56.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorConstant.primary,
          disabledBackgroundColor: ColorConstant.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ColorConstant.white,
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: textColor ?? ColorConstant.white,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
              ),
      ),
    );
  }
}