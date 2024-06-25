import 'package:web3dart/web3dart.dart';

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKeyFromMnemonic(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
  Future<void> importWalletFromSeed(String mnemonic);
  Future<void> importWalletFromPrivateKey(String privateKey);
}
