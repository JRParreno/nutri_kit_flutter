// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final bool isObscureText;
  final Widget? suffixIcon;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return '$hintText is missing';
            }
            return null;
          },
    );
  }
}
