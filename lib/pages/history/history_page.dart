import 'package:flutter/material.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/services/history_service_impl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    HistoryServiceImpl().fetchHistory(walletAddress: "0x932cA578e847C75c3CfeE499ff7bae81808f842B");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
            child: Text(
              "History",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        ],
      )),
    );
  }
}
