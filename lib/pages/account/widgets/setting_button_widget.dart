import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/resources/assets.dart';
import 'package:web3_wallet/resources/resources.dart';

class SettingButton extends StatelessWidget {
  final String iconPath;
  final Color iconBgColor;
  final String text;
  final Function()? onTap;

  const SettingButton({
    super.key,
    required this.iconPath,
    required this.iconBgColor,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        radius: 20,
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: iconBgColor,
                child: CustomSvgImage(
                  imagePath: iconPath,
                  width: 25,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                text,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              CustomSvgImage(
                imagePath: AppAssets.icChevronRight,
                width: 20,
                color: appColors.subTitle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
