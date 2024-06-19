import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3_wallet/providers/wallet_provider.dart';
import 'package:web3_wallet/repository/wallet_repository.dart';
import 'home/home_page.dart';
import 'create_or_import.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final securedStorageWalletRepository = SecureStorageWalletRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: securedStorageWalletRepository.getPrivateKey(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle errors
        } else {
          if (snapshot.data == null) {
            // If private key doesn't exist, load CreateOrImportPage
            return const CreateOrImportPage();
          } else {
            // If private key exists, load WalletPage
            return const HomePage();
          }
        }
      },
    );
  }
}
