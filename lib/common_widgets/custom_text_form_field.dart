import 'package:flutter/material.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/resources/resources.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final EdgeInsetsGeometry? padding;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextStyle? style;

  const CustomTextFormField._({
    this.controller,
    required this.hintText,
    this.backgroundColor,
    this.hintTextColor,
    this.padding,
    this.validator,
    this.obscureText = false,
    this.style,
  });

  factory CustomTextFormField.primary({
    TextEditingController? controller,
    required BuildContext context,
    required String hintText,
    Color? backgroundColor,
    Color? hintTextColor,
    EdgeInsetsGeometry? padding,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextStyle? style,
  }) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return CustomTextFormField._(
      controller: controller,
      hintText: hintText,
      backgroundColor: backgroundColor ?? appColors.bgCard1,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      hintTextColor: hintTextColor ?? appColors.subTitle,
      validator: validator,
      obscureText: obscureText,
      style: style ?? Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: hintTextColor),
        disabledBorder: InputBorder.none,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppDimensions.defaultTextFieldBorderRadius),
        ),
        contentPadding: padding,
        fillColor: backgroundColor,
        filled: true,
      ),
      style: style,
      cursorHeight: 25,
      validator: validator,
      obscureText: obscureText,
    );
  }
}
