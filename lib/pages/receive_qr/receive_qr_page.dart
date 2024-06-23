import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/custom_button_widget.dart';
import 'package:web3_wallet/constants/dimensions.dart';
import 'package:web3_wallet/resources/resources.dart';

class ReceiveQRPage extends StatelessWidget {
  const ReceiveQRPage({super.key});

  static const String routeName = "/receive-qr";

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<WalletCubit, WalletState>(
                      builder: (context, state) {
                        if (state is WalletLoaded) {
                          return QrImageView(
                            size: 300,
                            data: state.walletAddress,
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.circle,
                              color: appColors.softPurple,
                            ),
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.circle,
                              color: appColors.softRed,
                            ),
                          );
                        }
                        if (state is WalletError) {
                          return const Text("Something went wrong. Please try again later.");
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoaded) {
                    return CustomButton.primaryButton(
                      context: context,
                      text: "Copy Address",
                      onTap: () => copyToClipboard(context: context, walletAddress: state.walletAddress),
                    );
                  }
                  if (state is WalletError) {
                    return const Text("Something went wrong. Please try again later.");
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void copyToClipboard({required BuildContext context, required String walletAddress}) {
    Clipboard.setData(ClipboardData(text: walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet Address was copied to Clipboard')),
    );
  }
}
