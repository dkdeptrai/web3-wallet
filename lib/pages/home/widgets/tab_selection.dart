import 'package:flutter/material.dart';
import 'package:web3_wallet/resources/resources.dart';

class TabSelection extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() onTap;

  const TabSelection({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: isSelected ? appColors.title : appColors.subTitle,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
