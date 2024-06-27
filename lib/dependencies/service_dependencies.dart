import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';

class ServiceDependencies {
  static Future<void> setUp(GetIt injector) async {
    injector.registerFactory<AuthService>(() => AuthServiceImpl());
    injector.registerFactory<WalletService>(() => WalletServiceImpl());
    injector.registerFactory<WalletAddressService>(() => ETHWalletService());
    injector.registerFactory<ETHWalletService>(() => ETHWalletService());
    injector.registerLazySingleton<SepoliaTransactionService>(() => SepoliaTransactionService());
    injector.registerLazySingleton<MarketService>(() => MarketServiceImpl());
    injector.registerLazySingleton<TokenService>(() => TokenServiceImpl());
    injector.registerLazySingleton<OtherTokenService>(() => OtherTokenService(null));
    injector.registerLazySingleton<HistoryService>(() => HistoryServiceImpl());
    injector.registerLazySingleton<NewsService>(() => NewsServiceImpl());
    injector.registerLazySingleton<PendingTransactionServiceImpl>(() => PendingTransactionServiceImpl());
  }
}
