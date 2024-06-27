import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/utils/address_util.dart';
import 'package:web3_wallet/utils/date_time_format_util.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<HistoryCubit>().loadHistory();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        context.read<HistoryCubit>().loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(2, -0.8),
            child: Container(
              height: size.height * 0.2,
              width: size.height * 0.2,
              decoration: BoxDecoration(
                color: appColors.pink.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(-1.8, 0),
            child: Container(
              height: size.height * 0.2,
              width: size.height * 0.2,
              decoration: BoxDecoration(
                color: appColors.softPurple2.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: Colors.transparent),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
                child: Text(
                  "History",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, walletState) {
                    if (walletState is WalletLoaded) {
                      final walletAddress = walletState.walletAddress;

                      return BlocBuilder<HistoryCubit, HistoryState>(
                        builder: (context, historyState) {
                          if (historyState is HistoryLoading) {
                            return const Center(child: CustomLoadingWidget());
                          }
                          if (historyState is HistoryError) {
                            return const Center(
                              child: Text("Something went wrong. Please try again."),
                            );
                          }
                          if (historyState is HistoryLoaded) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                await _onRefreshHistory();
                              },
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: MediaQuery.of(context).size.height, // Ensure it takes up the entire screen
                                ),
                                child: ListView.separated(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                    left: AppDimensions.defaultHorizontalPadding,
                                    right: AppDimensions.defaultHorizontalPadding,
                                    bottom: 20,
                                  ),
                                  itemCount: historyState.transactions.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == historyState.transactions.length) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: CustomLoadingWidget(size: 30),
                                        ),
                                      );
                                    }

                                    final transaction = historyState.transactions[index];
                                    double value = transaction.value ?? 0;
                                    if (transaction.from == walletAddress) {
                                      value = -value;
                                    }

                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: appColors.bgCard1,
                                          child: CustomSvgImage(
                                            imagePath: value >= 0 ? AppAssets.icReceive : AppAssets.icSend,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                transaction.hash != null ? AddressUtil.hideAddress(transaction.hash!) : "Not found",
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                              Text(
                                                "From: ${transaction.from != null ? AddressUtil.hideAddress(transaction.from!) : "Not found"}",
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appColors.title),
                                              ),
                                              if (transaction.metadata?.blockTimestamp != null)
                                                Text(
                                                  DateTimeFormatUtil.formatDateTime(
                                                      transaction.metadata!.blockTimestamp!.add(const Duration(hours: 7))),
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: appColors.title),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          "$value ${transaction.asset ?? ""}",
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 20);
                                  },
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
        ],
      )),
    );
  }

  Future<void> _onRefreshHistory() async {
    await context.read<HistoryCubit>().loadHistory();
  }
}
