import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:web3_wallet/resources/resources.dart';

class CustomLoadingWidget extends StatelessWidget {
  final int size;

  const CustomLoadingWidget({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return LoadingAnimationWidget.dotsTriangle(
      color: appColors.softPurple,
      size: 50,
    );
  }
}
