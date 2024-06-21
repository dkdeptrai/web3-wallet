import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/custom_svg_image.dart';
import 'package:web3_wallet/resources/colors.dart';

class NavBarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const NavBarItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return IconButton(
        onPressed: onTap,
        icon: CustomSvgImage(
          imagePath: iconPath,
          color: isSelected ? appColors.title : appColors.bgGrey1,
        ));
  }
}
