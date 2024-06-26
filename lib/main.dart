import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:web3_wallet/blocs/blocs.dart';
import 'package:web3_wallet/dependencies/app_dependencies.dart';
import 'package:web3_wallet/http_override.dart';
import 'package:web3_wallet/pages/pages.dart';
import 'package:web3_wallet/resources/resources.dart';
import 'package:web3_wallet/router/router.dart';
import 'providers/wallet_provider.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final storage = FlutterSecureStorage();
  // await storage.deleteAll();

  WalletProvider walletProvider = WalletProvider();
  await walletProvider.loadPrivateKey();

  await AppDependencies.setUp();

  runApp(
    ChangeNotifierProvider<WalletProvider>.value(
      value: walletProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
            create: (context) => AuthenticationCubit()),
        BlocProvider<CreatePasswordCubit>(
            create: (context) => CreatePasswordCubit()),
        BlocProvider<WalletCubit>(create: (context) => WalletCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<TokensCubit>(create: (context) => TokensCubit()),
        BlocProvider<SendTokensCubit>(create: (context) => SendTokensCubit()),
        BlocProvider<ImportFromSeedCubit>(
            create: (context) => ImportFromSeedCubit()),
        BlocProvider<NewsCubit>(create: (context) => NewsCubit()),
        BlocProvider<HistoryCubit>(create: (context) => HistoryCubit()),
      ],
      child: MaterialApp(
        theme: AppThemes().lightTheme,
        darkTheme: AppThemes().darkTheme,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: AuthControlWrapperPage.routeName,
        onGenerateRoute: (settings) => Routes().onGenerateRoute(settings),
      ),
    );
  }
}
