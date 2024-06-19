import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/dependencies/page_dependencies.dart';

class AppDependencies {
  static GetIt get injector => GetIt.I;
  static Future<void> setUp() async {
    injector.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

    await PageDependencies.setup(injector);
  }
}
