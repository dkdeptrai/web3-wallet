import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/resources/colors.dart';

class NavBar extends StatelessWidget {
  final List<String> imagePaths;
  final Function(int) onTap;
  final int currentIndex;

  const NavBar({
    super.key,
    required this.imagePaths,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: appColors.bgCard1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(imagePaths.length, (index) {
          return NavBarItem(
            iconPath: imagePaths[index],
            label: "",
            isSelected: index == currentIndex,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }
}
