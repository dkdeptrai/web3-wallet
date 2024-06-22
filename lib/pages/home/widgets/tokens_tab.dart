import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/utils/validator_util.dart';

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

    return SingleChildScrollView(
      child: Column(
        children: [
          CustomButton.secondaryButton(
            context: context,
            text: "Import Token",
            onTap: () => showImportTokenDialog(context),
          ),
          BlocBuilder<TokensCubit, TokensState>(
            builder: (context, state) {
              if (state is TokensLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TokensLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.tokens.length,
                  itemBuilder: (context, index) {
                    final token = state.tokens[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      title: Text(
                        token.name.replaceAll("[", "").replaceAll("]", ""),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: appColors.softPurple),
                      ),
                      subtitle: Text(
                        token.symbol.replaceAll("[", "").replaceAll("]", ""),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: appColors.softPurple),
                      ),
                      trailing: Text(
                        token.balance,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
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
      ),
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
}

class ImportTokenDialog extends StatefulWidget {
  const ImportTokenDialog({super.key});

  @override
  State<ImportTokenDialog> createState() => _ImportTokenDialogState();
}

class _ImportTokenDialogState extends State<ImportTokenDialog> {
  final TokenService tokenService = GetIt.I<TokenService>();
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Form(
      key: _formKey,
      child: AlertDialog(
        backgroundColor: appColors.bgCard1,
        content: SizedBox(
          width: size.width - 2 * AppDimensions.defaultHorizontalPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.imgRobot3WithBg, height: 150),
              const SizedBox(height: 10),
              Text(
                "Enter Token Address",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: appColors.softPurple),
              ),
              const SizedBox(height: 30),
              CustomTextFormField.primary(
                controller: controller,
                context: context,
                hintText: "Token Address",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter address!";
                  }
                  if (!ValidatorUtil.isValidTokenAddress(value)) {
                    return "Please enter a valid address!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomButton.secondaryButton(
                context: context,
                onTap: () => _onImportToken(controller.text),
                text: "Authenticate",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onImportToken(String address) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    address = controller.text.trim();
    tokenService.importToken(address: address);
    Navigator.of(context).pop();
  }
}
