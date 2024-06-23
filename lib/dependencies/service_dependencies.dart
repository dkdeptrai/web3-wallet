import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';

class ServiceDependencies {
  static Future<void> setUp(GetIt injector) async {
    injector.registerFactory<WalletService>(() => WalletServiceImpl());
    injector.registerFactory<ETHWalletService>(() => ETHWalletService());
    injector.registerFactory<SepoliaTransactionService>(() => SepoliaTransactionService());
    injector.registerLazySingleton<MarketService>(() => MarketServiceImpl());
    injector.registerLazySingleton<TokenService>(() => TokenServiceImpl());
    injector.registerLazySingleton<OtherTokenService>(() => OtherTokenService(null));
  }
}