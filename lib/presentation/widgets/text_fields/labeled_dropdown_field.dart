import 'package:flutter/material.dart';
import '../../../core/app_theme/color_constant.dart';
import '../../../core/app_theme/font_constant.dart';

class LabeledDropdownField extends StatelessWidget {
  final String label;
  final String placeholder;
  final Color primaryColor;
  final Color textColor;
  final String? value;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const LabeledDropdownField({
    Key? key,
    required this.label,
    required this.placeholder,
    this.primaryColor = ColorConstant.primary,
    this.textColor = ColorConstant.black,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: FontConstant.fontSize14,
            fontWeight: FontConstant.medium,
            color: textColor,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          validator: validator,
          icon: const Icon(Icons.arrow_drop_down, color: ColorConstant.grey),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: ColorConstant.grey,
              fontSize: FontConstant.fontSize14,
              fontFamily: FontConstant.robotoFontFamily,
            ),
            filled: true,
            fillColor: ColorConstant.fieldBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20, // Match LabeledTextField
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorConstant.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ColorConstant.error,
                width: 2,
              ),
            ),
          ),
          style: TextStyle(
            fontSize: FontConstant.fontSize14,
            fontFamily: FontConstant.robotoFontFamily,
            color: textColor,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
