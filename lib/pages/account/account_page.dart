import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:web3_wallet/common_widgets/custom_button_widget.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/pages/account/widgets/update_profile_dialog.dart';
import 'package:web3_wallet/pages/account/widgets/widgets.dart';
import 'package:web3_wallet/pages/contacts_page/contacts_page.dart';
import 'package:web3_wallet/pages/preferences_page/preferences_page.dart';
import 'package:web3_wallet/resources/resources.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name = "Name"; // Store updated name

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(-1.5, -0.5),
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
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(color: Colors.transparent),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.defaultHorizontalPadding),
                  child: Text(
                    "Account",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _showUpdateProfileDialog(context),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          left: AppDimensions.defaultHorizontalPadding,
                          right: AppDimensions.defaultHorizontalPadding,
                          top: 25,
                          bottom: 35,
                        ),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: appColors.pink,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Email@gmail.com",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        AppAssets.imgRobot3,
                        width: size.width * 0.3,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: AppDimensions.defaultHorizontalPadding,
                      right: AppDimensions.defaultHorizontalPadding,
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.bgCard2,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SettingButton(
                          iconPath: AppAssets.icPreferences,
                          iconBgColor: appColors.orange.withOpacity(0.2),
                          text: "Preferences",
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        SettingButton(
                          iconPath: AppAssets.icHelp,
                          iconBgColor: appColors.orange.withOpacity(0.2),
                          text: "Help",
                        ),
                        const SizedBox(height: 10),
                        SettingButton(
                          iconPath: AppAssets.icProfile,
                          iconBgColor: appColors.orange.withOpacity(0.2),
                          text: "Contacts",
                          onTap: () => Navigator.pushNamed(
                              context, ContactsPage.routeName),
                        ),
                        const SizedBox(height: 40),
                        CustomButton.secondaryButton(
                          context: context,
                          text: "Logout",
                          onTap: () => _onLogout(context),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateProfileDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => UpdateProfileDialog(
        currentName: name, // Pass current name
      ),
    );

    if (result != null && result['name'] != null) {
      setState(() {
        name = result['name']; // Update name
      });
    }
  }

  void _onLogout(BuildContext context) {
    context.read<AuthenticationCubit>().logout();
  }
}
