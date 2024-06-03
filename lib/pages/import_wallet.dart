import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3_wallet/providers/wallet_provider.dart';
import 'package:web3_wallet/pages/wallet.dart';
import 'package:web3_wallet/repository/wallet_repository.dart';
import 'package:web3_wallet/services/wallet_address_service.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({Key? key}) : super(key: key);

  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  bool isVerified = false;
  String verificationText = '';
  String privateKeyText = '';

  void navigateToWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WalletPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletService = ETHWalletService();
    void importWallet() async {
      try {
        verificationText = verificationText.trim();
        setState(() {
          isVerified = true;
        });
        walletService.importWalletFromSeed(verificationText);
        navigateToWalletPage();
      } catch (e) {
        setState(() {
          isVerified = false;
          verificationText = '';
        });
        print('failed to import wallet: ${e}');
      }
    }

    void importWithPrivateKey2() async {
      try {
        privateKeyText = privateKeyText.trim();
        setState(() {
          isVerified = true;
        });
        walletService.importWalletFromPrivateKey(privateKeyText);
        navigateToWalletPage();
      } catch (e) {
        setState(() {
          isVerified = false;
          privateKeyText = '';
        });
        print('failed to import wallet: ${e}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Seed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please Enter your mnemonic phrase:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  verificationText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter mnemonic phrase',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: importWallet,
              child: const Text('Import'),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Or your private key, make sure no one is looking at your screen:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  privateKeyText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter Private Key',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: importWithPrivateKey2,
              child: const Text('Import'),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
