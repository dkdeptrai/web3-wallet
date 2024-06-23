import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/pages/pages.dart';

class PageDependencies {
  static Future<void> setup(GetIt injector) async {
    injector.registerFactory<Widget>(() => const AuthControlWrapperPage(), instanceName: AuthControlWrapperPage.routeName);
    injector.registerFactory<Widget>(() => const ChooseLoginMethodPage(), instanceName: ChooseLoginMethodPage.routeName);
    injector.registerFactory<Widget>(() => const CreatePasswordPage(), instanceName: CreatePasswordPage.routeName);
    injector.registerFactory<Widget>(() => const CreatePasswordSuccess(), instanceName: CreatePasswordSuccess.routeName);
    injector.registerFactory<Widget>(() => const MainPage(), instanceName: MainPage.routeName);
    injector.registerFactory<Widget>(() => const HomePage(), instanceName: HomePage.routeName);
    injector.registerFactory<Widget>(() => const SendTokensPage(), instanceName: SendTokensPage.routeName);
    injector.registerFactory<Widget>(() => const ReceiveQRPage(), instanceName: ReceiveQRPage.routeName);
    injector.registerFactory<Widget>(() => const QRScannerPage(), instanceName: QRScannerPage.routeName);
  }
}
