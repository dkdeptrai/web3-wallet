import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/custom_svg_image.dart';
import 'package:web3_wallet/extensions/extensions.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/utils/decimal_format_util.dart';

class TrendingItemWidget extends StatelessWidget {
  final String name;
  final String symbol;
  final String code;
  final String imagePath;
  final double rate;
  final dynamic hourDelta;
  final String colorCode;

  const TrendingItemWidget({
    super.key,
    required this.name,
    required this.code,
    required this.symbol,
    required this.imagePath,
    required this.rate,
    required this.hourDelta,
    required this.colorCode,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final hourDeltaDouble =
        (hourDelta is int) ? hourDelta.toDouble() : hourDelta;
    final deltaPercentage = (hourDeltaDouble - 1) * 100;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor:
              Color(int.parse("0xFF${colorCode.replaceAll("#", "")}"))
                  .withOpacity(0.2),
          radius: 25,
          child: Image.network(imagePath, width: 30, height: 30),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 5),
            Text(
              code,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: appColors.subTitle),
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
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSvgImage(
                  imagePath: deltaPercentage > 0
                      ? AppAssets.icChevronUp
                      : AppAssets.icChevronDown,
                  width: 16,
                  height: 16,
                  color: deltaPercentage > 0 ? appColors.green : appColors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  "${DecimalFormatUtil.formatDouble(deltaPercentage)}%",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: appColors.subTitle),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
