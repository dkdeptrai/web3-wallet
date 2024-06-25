import 'package:flutter/material.dart';
import 'package:web3_wallet/common_widgets/common_widgets.dart';
import 'package:web3_wallet/pages/home/home_page.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/assets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const String routeName = "/main";

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<String> imagePaths = [
    AppAssets.icHome,
    AppAssets.icMarket,
    AppAssets.icInsights,
    AppAssets.icProfile,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavBar(
        imagePaths: imagePaths,
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(),
          Container(color: Colors.red),
          Container(color: Colors.green),
          AccountPage(),
        ],
      ),
    );
  }
}
