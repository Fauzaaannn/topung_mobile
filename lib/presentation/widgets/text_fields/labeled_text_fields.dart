import 'package:flutter/material.dart';
import '../../../core/app_theme/color_constant.dart';
import '../../../core/app_theme/font_constant.dart';

class LabeledTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextInputType textFieldType;
  final Color primaryColor;
  final Color textColor;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int maxLines;

  const LabeledTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    this.textFieldType = TextInputType.text,
    this.primaryColor = ColorConstant.primary,
    this.textColor = ColorConstant.black,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: FontConstant.fontSize14,
            fontWeight: FontConstant.medium,
            color: widget.textColor,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.textFieldType,
          obscureText: _obscureText,
          maxLines: _obscureText ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: ColorConstant.grey,
              fontSize: FontConstant.fontSize14,
              fontFamily: FontConstant.robotoFontFamily,
            ),
            filled: true,
            fillColor: ColorConstant.fieldBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ColorConstant.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
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
              borderSide: BorderSide(color: widget.primaryColor, width: 2),
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
            color: widget.textColor,
          ),
        ),
      ],
    );
  }
}
