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
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return TrendingItemWidget(
                  name: item['name'] ?? "",
                  code: item['code'] ?? "",
                  symbol: item['symbol'] ?? "",
                  imagePath: item['png64'] ?? "",
                  rate: item['rate'] ?? 0.0,
                  hourDelta: item['delta']['hour'] ?? "",
                );
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomLoadingWidget(),
            );
          }
          return Center(
            child: Text("No data"),
          );
        });
  }
}
