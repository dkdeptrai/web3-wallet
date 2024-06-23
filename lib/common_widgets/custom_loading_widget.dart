import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web3_wallet/resources/resources.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return LoadingAnimationWidget.dotsTriangle(
      color: appColors.softPurple,
      size: 50,
    );
  }
}
