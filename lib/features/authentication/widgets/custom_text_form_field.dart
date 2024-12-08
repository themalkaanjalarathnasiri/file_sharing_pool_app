import 'package:flutter/material.dart';
import 'package:share_pool/common/theme/app_theme.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  String hintText;
  Widget? suffixWidget;
  bool? isObscureText;
  bool? readOnly;
  TextInputType keyboardType;
  String? Function(String?)? validator;
  CustomTextFormField(
      {required this.controller,
      required this.hintText,
      this.suffixWidget,
      this.isObscureText,
      required this.keyboardType,
      this.validator,
      this.readOnly,
      super.key});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly??false,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      obscureText: widget.isObscureText ?? false,
      style: TextStyle(color: Colors.grey.shade300),
      cursorErrorColor: AppTheme.textfieldErrorColor,

      decoration: InputDecoration(
        errorMaxLines: 4,
          suffixIconColor: Colors.white,
          hintText: widget.hintText,
          errorStyle: const TextStyle(color: AppTheme.textfieldErrorColor),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: widget.suffixWidget,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.textfieldErrorColor),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.textfieldErrorColor),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
      validator: widget.validator,
    );
  }
}
