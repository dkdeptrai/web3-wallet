import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/pages/home/widgets/widgets.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/resources.dart';

class TokensTab extends StatefulWidget {
  const TokensTab({super.key});

  @override
  State<TokensTab> createState() => _TokensTabState();
}

class _TokensTabState extends State<TokensTab> {
  @override
  void initState() {
    final walletCubit = context.read<WalletCubit>();
    if (walletCubit.state is WalletLoaded) {
      context.read<TokensCubit>().loadTokens((walletCubit.state as WalletLoaded).walletAddress);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Column(
      children: [
        CustomButton.secondaryButton(
          context: context,
          text: "Import Token",
          onTap: () => showImportTokenDialog(context),
        ),
        BlocBuilder<TokensCubit, TokensState>(
          builder: (context, state) {
            if (state is TokensLoading) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(30.0),
                child: CustomLoadingWidget(),
              ));
            } else if (state is TokensLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.tokens.length,
                itemBuilder: (context, index) {
                  final token = state.tokens[index];
                  final String name = token.name.replaceAll("[", "").replaceAll("]", "");
                  final String symbol = token.symbol.replaceAll("[", "").replaceAll("]", "");
                  return Material(
                    color: Colors.transparent,
                    shadowColor: appColors.bgCardTransparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      onTap: () => _onTokenCardTap(
                        contractAddress: token.contractAddress,
                        tokenSymbol: symbol,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: appColors.bgScreen,
                        radius: 25,
                        child: Text(
                          symbol[0],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                        ),
                      ),
                      title: Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                      ),
                      subtitle: Text(
                        symbol,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: appColors.softPurple),
                      ),
                      trailing: Text(
                        token.balance,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
                      ),
                    ),
                  );
                },
              );
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: state.tokens.map((token) {
              //     return Row(
              //       children: [
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               token.name.replaceAll("[", "").replaceAll("]", ""),
              //               style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).extension<AppColors>()!.softPurple),
              //             ),
              //             Text(
              //               token.symbol,
              //               style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).extension<AppColors>()!.softPurple),
              //             ),
              //           ],
              //         ),
              //         const Spacer(),
              //         Text(
              //           token.balance,
              //           style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).extension<AppColors>()!.softPurple),
              //         ),
              //       ],
              //     );
              //   }).toList(),
              // );
            } else if (state is TokensError) {
              return Center(
                  child: Text(
                "Something went wrong: ${state.message}",
                style: Theme.of(context).textTheme.titleSmall,
              ));
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Future<void> showImportTokenDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ImportTokenDialog();
      },
    );
  }

  void _onTokenCardTap({required String? contractAddress, required String? tokenSymbol}) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final Size size = MediaQuery.of(context).size;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: appColors.bgCard1,
            content: SizedBox(
              width: size.width - 2 * AppDimensions.defaultHorizontalPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: appColors.bgScreen,
                    radius: 35,
                    child: Text(
                      tokenSymbol?[0] ?? '',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: appColors.softPurple),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(tokenSymbol ?? '', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple)),
                  const SizedBox(height: 30),
                  CustomButton.primaryButton(
                    context: context,
                    onTap: () => _onSendTokenOption(contractAddress: contractAddress, tokenSymbol: tokenSymbol),
                    text: "Send",
                  ),
                  const SizedBox(height: 20),
                  CustomButton.secondaryButton(
                    context: context,
                    onTap: () {},
                    text: "Remove",
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onSendTokenOption({required String? contractAddress, required String? tokenSymbol}) {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      SendTokensPage.routeName,
      arguments: {
        "contractAddress": contractAddress,
        "tokenSymbol": tokenSymbol,
      },
    );
  }
}
