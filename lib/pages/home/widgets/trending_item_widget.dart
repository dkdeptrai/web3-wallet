import 'package:flutter/material.dart';
import 'package:web3_wallet/extensions/extensions.dart';
import 'package:web3_wallet/resources/resources.dart';

class TrendingItemWidget extends StatelessWidget {
  final String name;
  final String symbol;
  final String code;
  final String imagePath;
  final double rate;
  final hourDelta;

  const TrendingItemWidget({
    super.key,
    required this.name,
    required this.code,
    required this.symbol,
    required this.imagePath,
    required this.rate,
    this.hourDelta,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Image.network(imagePath, width: 40, height: 40),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              code,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.subTitle),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rate.toCurrencyFormat,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              "\$$hourDelta",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: appColors.subTitle),
            ),
          ],
        ),
      ],
    );
  }
}
