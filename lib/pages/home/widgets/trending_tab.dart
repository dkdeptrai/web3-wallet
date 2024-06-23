import 'package:flutter/material.dart';
import 'package:web3_wallet/pages/home/widgets/widgets.dart';

class TrendingTab extends StatelessWidget {
  const TrendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 20,
      itemBuilder: (context, index) {
        return TrendingItemWidget();
      },
    );
  }
}
