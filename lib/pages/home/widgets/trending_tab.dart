import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/common_widgets/custom_loading_widget.dart';
import 'package:web3_wallet/pages/home/widgets/widgets.dart';
import 'package:web3_wallet/services/interfaces/market_service.dart';

class TrendingTab extends StatelessWidget {
  const TrendingTab({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketService marketService = GetIt.I<MarketService>();
    return StreamBuilder(
        stream: marketService.getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                shrinkWrap: true,
                itemCount: data.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  final item = data[index];
                  return TrendingItemWidget(
                    name: item['name'] ?? "",
                    code: item['code'] ?? "",
                    symbol: item['symbol'] ?? "",
                    imagePath: item['png64'] ?? "",
                    rate: item['rate'] ?? 0.0,
                    hourDelta: item['delta']['hour'] ?? "",
                    colorCode: item['color'] ?? 0,
                  );
                },
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomLoadingWidget(),
            );
          }
          return const Center(
            child: Text("No data"),
          );
        });
  }
}
