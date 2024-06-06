import 'package:flutter/material.dart';
import 'package:web3_wallet/model/token_model.dart';
import 'package:web3_wallet/pages/create_or_import.dart';
import 'package:web3_wallet/repository/wallet_repository.dart';
import 'package:web3_wallet/services/transaction_service.dart';
import 'package:web3_wallet/services/wallet_address_service.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3_wallet/components/send_tokens.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final walletAddressService = ETHWalletService();
  final securedStorageWalletRepository = SecureStorageWalletRepository();
  late SepoliaTransactionService transactionService;
  String walletAddress = '';
  String balance = '';
  String pvKey = '';
  List<Token> tokens = [];

  @override
  void initState() {
    super.initState();
    transactionService = SepoliaTransactionService();
    _initializeService();
    loadWalletData();
    loadStoredTokens();
  }

  Future<void> _initializeService() async {
    await transactionService.init();
  }

  Future<void> loadWalletData() async {
    String? privateKey = await securedStorageWalletRepository.getPrivateKey();
    if (privateKey != null) {
      EthereumAddress address =
          await walletAddressService.getPublicKey(privateKey);
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print("Private Key: $pvKey");
      EtherAmount latestBalance =
          await transactionService.getBalance(address.hex);
      String latestBalanceInEther =
          latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latestBalanceInEther;
      });
    }
  }

  Future<void> loadStoredTokens() async {
    List<String>? tokenAddresses =
        await securedStorageWalletRepository.getStoredTokenAddresses();
    if (tokenAddresses != null && tokenAddresses.isNotEmpty) {
      for (String address in tokenAddresses) {
        late OtherTokenService otherTokenService = OtherTokenService(address);
        otherTokenService.init();

        Map<String, dynamic> tokenDetails =
            await otherTokenService.getTokenDetails();

        EtherAmount balance = await otherTokenService.getBalance(walletAddress);
        String balanceStr = balance.getValueInUnit(EtherUnit.ether).toString();

        print(
            "Checking token: ${tokenDetails['name']} (${tokenDetails['symbol']})");

        bool tokenExists = tokens.any((token) =>
            token.name == tokenDetails['name'] &&
            token.symbol == tokenDetails['symbol']);

        if (!tokenExists) {
          Token token = Token(
              name: tokenDetails['name'].toString(),
              symbol: tokenDetails['symbol'].toString(),
              balance: balanceStr);

          tokens.add(token);
        } else {
          print(
              "Duplicate token found: ${tokenDetails['name']} (${tokenDetails['symbol']})");
        }
      }
    }
  }

  Future<void> importToken() async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Import Token"),
            content: TextField(
                controller: controller,
                decoration:
                    InputDecoration(hintText: "Enter token contract address")),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    String address = controller.text.trim();
                    if (address.isNotEmpty) {
                      try {
                        await securedStorageWalletRepository
                            .saveTokenAddress(address);
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to import token: $e'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid address'),
                        ),
                      );
                    }
                  },
                  child: const Text("Import"))
            ],
          );
        });
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
                    onPressed: () async {
                      tokens.clear();
                      walletAddress = '';
                      balance = '';
                      await loadWalletData();
                      await loadStoredTokens();
                      setState(() {});
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
                        ListView.builder(
                          itemCount: tokens.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return ListTile(
                                title: const Text("Sepolia ETH"),
                                subtitle: Text(this.balance),
                              );
                            } else if (index == tokens.length + 1) {
                              return ListTile(
                                title: TextButton(
                                    onPressed: () async => await importToken(),
                                    child: const Text("Import Token")),
                              );
                            } else {
                              Token token = tokens[index - 1];
                              return ListTile(
                                title: Text(token.name),
                                subtitle: Text(token.balance),
                              );
                            }
                          },
                        ),

                        // Options Tab
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
