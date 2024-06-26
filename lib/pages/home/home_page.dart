import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/common_widgets/custom_svg_image.dart';
import 'package:web3_wallet/constants/dimensions.dart';
import 'package:web3_wallet/model/token_model.dart';
import 'package:web3_wallet/pages/home/widgets/trending_tab.dart';
import 'package:web3_wallet/pages/home/widgets/widgets.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3_wallet/utils/clipboard_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final securedStorageWalletRepository = GetIt.I<WalletService>();
  final MarketService marketService = GetIt.I<MarketService>();
  final SepoliaTransactionService transactionService = GetIt.I<SepoliaTransactionService>();
  final TokenService tokenService = GetIt.I<TokenService>();

  String walletAddress = '';
  String balance = '';
  String pvKey = '';
  List<Token> tokens = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<WalletCubit>().loadWallet();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Future<void> loadStoredTokens() async {
  //   List<String>? tokenAddresses = await securedStorageWalletRepository.getStoredTokenAddresses();
  //   if (tokenAddresses != null && tokenAddresses.isNotEmpty) {
  //     for (String address in tokenAddresses) {
  //       late OtherTokenService otherTokenService = OtherTokenService(address);
  //       otherTokenService.init();

  //       Map<String, dynamic> tokenDetails = await otherTokenService.getTokenDetails();

  //       EtherAmount balance = await otherTokenService.getBalance(walletAddress);
  //       String balanceStr = balance.getValueInUnit(EtherUnit.ether).toString();

  //       print("Checking token: ${tokenDetails['name']} (${tokenDetails['symbol']})");

  //       bool tokenExists = tokens.any((token) => token.name == tokenDetails['name'] && token.symbol == tokenDetails['symbol']);

  //       if (!tokenExists) {
  //         Token token = Token(name: tokenDetails['name'].toString(), symbol: tokenDetails['symbol'].toString(), balance: balanceStr);

  //         tokens.add(token);
  //       } else {
  //         print("Duplicate token found: ${tokenDetails['name']} (${tokenDetails['symbol']})");
  //       }
  //     }
  //   }
  // }

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
                      BlocBuilder<WalletCubit, WalletState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state is WalletLoaded ? "\$ ${state.balance}" : "...",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              if (state is WalletLoaded)
                                Row(
                                  children: [
                                    Text(
                                      "${state.walletAddress.substring(0, 6)}.....${state.walletAddress.substring(state.walletAddress.length - 4)}",
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: appColors.title),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () => _onCopyWalletAddress(state.walletAddress),
                                      icon: Icon(
                                        Icons.copy,
                                        color: appColors.title,
                                        size: 16,
                                      ),
                                    )
                                  ],
                                )
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
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
                                  onPressed: _navigateToSendTokenPage,
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
                                  onPressed: _navigateToReceiveTokenPage,
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
                                  icon: CustomSvgImage(
                                    imagePath: AppAssets.icReload,
                                    color: appColors.orange,
                                  ),
                                  onPressed: _onReload,
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
                  child: BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {
                      _pageController.jumpToPage(state.tabIndex);
                    },
                    builder: (context, state) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: AppDimensions.defaultHorizontalPadding,
                          right: AppDimensions.defaultHorizontalPadding,
                          top: 10,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.bgCard2,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TabSelection(
                                    text: "Trending",
                                    isSelected: state.tabIndex == 0,
                                    onTap: () => _onChangeTab(0),
                                  ),
                                ),
                                Expanded(
                                  child: TabSelection(
                                    text: "Tokens",
                                    isSelected: state.tabIndex == 1,
                                    onTap: () => _onChangeTab(1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: PageView(
                                controller: _pageController,
                                onPageChanged: (index) => _onChangeTab(index),
                                children: const [
                                  TrendingTab(),
                                  TokensTab(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
      //                   MaterialPageRoute(builder: (context) => SendTokensPage(privateKey: pvKey)),
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
      //                 // await loadWalletData();
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
      //                           title: TextButton(onPressed: () async => await importToken(), child: const Text("Import Token")),
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
      //                         await securedStorageWalletRepository.deletePrivateKey();

      //                         // ignore: use_build_context_synchronously
      //                         Navigator.pushAndRemoveUntil(
      //                           context,
      //                           MaterialPageRoute(
      //                             builder: (context) => const CreateOrImportPage(),
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

  void _onChangeTab(int newIndex) {
    context.read<HomeCubit>().changeTab(newIndex);
  }

  void _navigateToSendTokenPage() {
    Navigator.pushNamed(context, SendTokensPage.routeName);
  }

  void _navigateToReceiveTokenPage() {
    Navigator.pushNamed(context, ReceiveQRPage.routeName);
  }

  void _onReload() {
    context.read<WalletCubit>().loadWallet();
  }

  void _onCopyWalletAddress(String walletAddress) async {
    await ClipboardUtil.copyToClipboard(walletAddress);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallet address copied to clipboard')));
  }
}
