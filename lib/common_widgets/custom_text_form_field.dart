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
  final Widget? suffix;
  final Widget? prefix;
  final Widget? prefixIcon;
  final int? maxLines;

  const CustomTextFormField._({
    this.controller,
    required this.hintText,
    this.backgroundColor,
    this.hintTextColor,
    this.padding,
    this.validator,
    this.obscureText = false,
    this.style,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.maxLines,
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
    Widget? prefix,
    Widget? prefixIcon,
    Widget? suffix,
    int? maxLines = 1,
  }) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return CustomTextFormField._(
      controller: controller,
      hintText: hintText,
      backgroundColor: backgroundColor ?? appColors.bgCard1,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintTextColor: hintTextColor ?? appColors.subTitle,
      validator: validator,
      obscureText: obscureText,
      style: style ?? Theme.of(context).textTheme.headlineSmall,
      prefix: prefix,
      prefixIcon: prefixIcon,
      suffix: suffix,
      maxLines: maxLines,
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
        prefix: prefix,
        prefixIcon: prefixIcon,
        suffix: suffix,
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
      ),
      style: style,
      cursorHeight: 25,
      validator: validator,
      obscureText: obscureText,
      maxLines: maxLines,
    );
  }
}
