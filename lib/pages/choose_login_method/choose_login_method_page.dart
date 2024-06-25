import 'package:flutter/material.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';

import '../../resources/resources.dart';

class ChooseLoginMethodPage extends StatelessWidget {
  const ChooseLoginMethodPage({super.key});

  static const routeName = "/choose-login-method";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    const double robotImgSize = 232;

    return Scaffold(
      backgroundColor: appColors.purple,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 46,
            left: 30,
            child: Image.asset(AppAssets.imgBitcoin3),
          ),
          Positioned(
            top: 171,
            left: 0,
            child: Image.asset(AppAssets.imgOther3),
          ),
          Positioned(
            top: 41,
            right: 0,
            child: Image.asset(AppAssets.imgETH3),
          ),
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.348),
                  width: size.width,
                  height: size.height * 0.652,
                  padding: const EdgeInsets.only(top: 44, left: 25, right: 25),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    color: Color(0xFF141629),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Wallet Setup",
                        style: textTheme.displayLarge,
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text: "By using Robocoin wallet, you agree to the ",
                          style: textTheme.headlineMedium,
                          children: [
                            TextSpan(
                              text: "terms",
                              style: textTheme.headlineMedium?.copyWith(color: appColors.purple1),
                            ),
                            TextSpan(
                              text: " and ",
                              style: textTheme.headlineMedium,
                            ),
                            TextSpan(
                              text: "privacy policy",
                              style: textTheme.headlineMedium?.copyWith(color: appColors.purple1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.068),
                      CustomButton.primaryButton(
                        context: context,
                        onTap: () => _navigateToImportFromSeedPage(context),
                        text: "Import from seed phrase",
                      ),
                      const SizedBox(height: 40),
                      CustomButton.secondaryButton(
                        context: context,
                        onTap: () => _navigateToCreateWallet(context),
                        text: "Create new wallet",
                      ),
                      SizedBox(height: size.height * 0.2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.348 - robotImgSize + 40,
            child: Image.asset(AppAssets.imgRobot3),
          ),
        ],
      ),
    );
  }

  void _navigateToImportFromSeedPage(BuildContext context) {
    Navigator.pushNamed(context, ImportFromSeedPage.routeName);
  }

  void _navigateToCreateWallet(BuildContext context) {
    Navigator.pushNamed(context, CreatePasswordPage.routeName);
  }
}
