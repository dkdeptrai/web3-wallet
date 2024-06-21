import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvgImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? boxFit;

  const CustomSvgImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.color,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.contain,
      colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }
}
