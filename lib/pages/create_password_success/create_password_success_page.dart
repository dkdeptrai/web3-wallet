import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/pages/main/main_page.dart';
import 'package:web3_wallet/resources/resources.dart';

class CreatePasswordSuccess extends StatelessWidget {
  const CreatePasswordSuccess({super.key});

  static const String routeName = "/create-password-success";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Image.asset(AppAssets.imgRobot3WithBg),
                    Text(
                      "Create Wallet success!",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      "You've successfully protected your wallet. Remember to keep your seed phrase safe, it's your responsibility!",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      " RoboWallet cannot recover your wallet should you lose it. You can find your seed phrase in Settings > Preferences > Security & Privacy",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              CustomButton.primaryButton(
                context: context,
                text: "Done",
                onTap: () => _onDone(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDone(BuildContext context) {
    Navigator.pushNamed(context, MainPage.routeName);
  }
}
