import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/providers/wallet_provider.dart';
import 'package:web3_wallet/pages/create_or_import.dart';
import 'package:web3_wallet/repository/wallet_repository.dart';
import 'package:web3_wallet/services/wallet_address_service.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3_wallet/utils/get_balances.dart';
import 'package:web3_wallet/components/send_tokens.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final walletService = ETHWalletService();
  final securedStorageWalletRepository = SecureStorageWalletRepository();
  String walletAddress = '';
  String balance = '';
  String pvKey = '';

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    // final storage = FlutterSecureStorage();
    // String? privateKey = await storage.read(key: 'privateKey');
    String? privateKey = await securedStorageWalletRepository.getPrivateKey();
    if (privateKey != null) {
      // final walletProvider = WalletProvider();
      // await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletService.getPublicKey(privateKey);
      print("Public Address: ${address.hex}");
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print("Private Key: $pvKey");
      String response = await getBalances(address.hex, 'sepolia');

      String newBalance = response ?? '0';

      // Transform balance from wei to ether
      EtherAmount latestBalance =
          EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
      String latestBalanceInEther =
          latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latestBalanceInEther;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Wallet Address',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  walletAddress,
                  style: const TextStyle(fontSize: 20.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  balance,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'sendButton', // Unique tag for send button
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SendTokensPage(privateKey: pvKey)),
                      );
                    },
                    child: const Icon(Icons.send),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Send'),
                ],
              ),
              Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'refreshButton', // Unique tag for send button
                    onPressed: () {
                      setState(() {
                        loadWalletData();
                        print(pvKey);
                      });
                    },
                    child: const Icon(Icons.replay_outlined),
                  ),
                  const SizedBox(height: 8.0),
                  const Text('Refresh'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Assets'),
                      Tab(text: 'Options'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Assets Tab
                        Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sepolia ETH',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      balance,
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        // NFTs Tab
                        // Activities Tab
                        Center(
                          child: ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () async {
                              await securedStorageWalletRepository
                                  .deletePrivateKey();

                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateOrImportPage(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
