import 'package:flutter/material.dart';
import 'package:web3_wallet/resources/resources.dart';

class TrendingItemWidget extends StatelessWidget {
  const TrendingItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Image.asset(AppAssets.imgBitcoin3),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bitcoin",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              "BTC",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.subTitle),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\$213",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              "BTC",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.subTitle),
            ),
          ],
        ),
      ],
    );
  }
}
