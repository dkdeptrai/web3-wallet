import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:web3_wallet/constants/dimensions.dart';
import 'package:web3_wallet/model/token_model.dart';
import 'package:web3_wallet/pages/home/widgets/widgets.dart';
import 'package:web3_wallet/repository/wallet_repository.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      EthereumAddress address = await walletAddressService.getPublicKey(privateKey);
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print("Private Key: $pvKey");
      EtherAmount latestBalance = await transactionService.getBalance(address.hex);
      String latestBalanceInEther = latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latestBalanceInEther;
      });
    }
  }

  Future<void> loadStoredTokens() async {
    List<String>? tokenAddresses = await securedStorageWalletRepository.getStoredTokenAddresses();
    if (tokenAddresses != null && tokenAddresses.isNotEmpty) {
      for (String address in tokenAddresses) {
        late OtherTokenService otherTokenService = OtherTokenService(address);
        otherTokenService.init();

        Map<String, dynamic> tokenDetails = await otherTokenService.getTokenDetails();

        EtherAmount balance = await otherTokenService.getBalance(walletAddress);
        String balanceStr = balance.getValueInUnit(EtherUnit.ether).toString();

        print("Checking token: ${tokenDetails['name']} (${tokenDetails['symbol']})");

        bool tokenExists = tokens.any((token) => token.name == tokenDetails['name'] && token.symbol == tokenDetails['symbol']);

        if (!tokenExists) {
          Token token = Token(name: tokenDetails['name'].toString(), symbol: tokenDetails['symbol'].toString(), balance: balanceStr);

          tokens.add(token);
        } else {
          print("Duplicate token found: ${tokenDetails['name']} (${tokenDetails['symbol']})");
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
            decoration: const InputDecoration(hintText: "Enter token contract address"),
          ),
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
                      await securedStorageWalletRepository.saveTokenAddress(address);
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
      },
    );
  }

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
              alignment: const AlignmentDirectional(1.5, -0.8),
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
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Container(
                height: size.height * 0.2,
                width: size.height * 0.2,
                decoration: BoxDecoration(
                  color: appColors.softPurple2.withOpacity(0.5),
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
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
                  child: Text(
                    "Home",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
                  child: Text(
                    "Your wallet",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppDimensions.defaultHorizontalPadding),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: appColors.bgBlurModal,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total balance",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\$ 32.00",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: appColors.bgCard1,
                                child: IconButton(
                                  padding: const EdgeInsets.all(20),
                                  onPressed: () {},
                                  icon: SvgPicture.asset(AppAssets.icSend),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Send",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: appColors.bgCard1,
                                child: IconButton(
                                  padding: const EdgeInsets.all(20),
                                  icon: SvgPicture.asset(AppAssets.icReceive),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Receive",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: appColors.bgCard1,
                                child: IconButton(
                                  padding: const EdgeInsets.all(20),
                                  icon: SvgPicture.asset(AppAssets.icReceive),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Reload",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
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
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trending",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return TrendingItemWidget();
                            },
                          ),
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
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     Container(
      //       height: MediaQuery.of(context).size.height * 0.4,
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Text(
      //             'Wallet Address',
      //             style: TextStyle(
      //               fontSize: 24.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //           const SizedBox(height: 16.0),
      //           Text(
      //             walletAddress,
      //             style: const TextStyle(fontSize: 20.0),
      //             textAlign: TextAlign.center,
      //           ),
      //           const SizedBox(height: 32.0),
      //           const Text(
      //             'Balance',
      //             style: TextStyle(
      //               fontSize: 24.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //           const SizedBox(height: 16.0),
      //           Text(
      //             balance,
      //             style: const TextStyle(
      //               fontSize: 20.0,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //         ],
      //       ),
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         Column(
      //           children: [
      //             FloatingActionButton(
      //               heroTag: 'sendButton', // Unique tag for send button
      //               onPressed: () {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) =>
      //                           SendTokensPage(privateKey: pvKey)),
      //                 );
      //               },
      //               child: const Icon(Icons.send),
      //             ),
      //             const SizedBox(height: 8.0),
      //             const Text('Send'),
      //           ],
      //         ),
      //         Column(
      //           children: [
      //             FloatingActionButton(
      //               heroTag: 'refreshButton', // Unique tag for send button
      //               onPressed: () async {
      //                 tokens.clear();
      //                 walletAddress = '';
      //                 balance = '';
      //                 await loadWalletData();
      //                 await loadStoredTokens();
      //                 setState(() {});
      //               },
      //               child: const Icon(Icons.replay_outlined),
      //             ),
      //             const SizedBox(height: 8.0),
      //             const Text('Refresh'),
      //           ],
      //         ),
      //       ],
      //     ),
      //     const SizedBox(height: 30.0),
      //     Expanded(
      //       child: DefaultTabController(
      //         length: 2,
      //         child: Column(
      //           children: [
      //             const TabBar(
      //               labelColor: Colors.blue,
      //               tabs: [
      //                 Tab(text: 'Assets'),
      //                 Tab(text: 'Options'),
      //               ],
      //             ),
      //             Expanded(
      //               child: TabBarView(
      //                 children: [
      //                   // Assets Tab
      //                   ListView.builder(
      //                     itemCount: tokens.length + 2,
      //                     itemBuilder: (context, index) {
      //                       if (index == 0) {
      //                         return ListTile(
      //                           title: const Text("Sepolia ETH"),
      //                           subtitle: Text(this.balance),
      //                         );
      //                       } else if (index == tokens.length + 1) {
      //                         return ListTile(
      //                           title: TextButton(
      //                               onPressed: () async => await importToken(),
      //                               child: const Text("Import Token")),
      //                         );
      //                       } else {
      //                         Token token = tokens[index - 1];
      //                         return ListTile(
      //                           title: Text(token.name),
      //                           subtitle: Text(token.balance),
      //                         );
      //                       }
      //                     },
      //                   ),

      //                   // Options Tab
      //                   Center(
      //                     child: ListTile(
      //                       leading: const Icon(Icons.logout),
      //                       title: const Text('Logout'),
      //                       onTap: () async {
      //                         await securedStorageWalletRepository
      //                             .deletePrivateKey();

      //                         // ignore: use_build_context_synchronously
      //                         Navigator.pushAndRemoveUntil(
      //                           context,
      //                           MaterialPageRoute(
      //                             builder: (context) =>
      //                                 const CreateOrImportPage(),
      //                           ),
      //                           (route) => false,
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
