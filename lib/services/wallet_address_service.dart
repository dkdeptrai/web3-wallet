import 'package:dart_bip32_bip44_noflutter/dart_bip32_bip44_noflutter.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;

class ETHWalletService implements WalletAddressService {
  final walletRepository = GetIt.I<WalletService>();

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKeyFromMnemonic(String mnemonic) async {
    const String path = 'm/44\'/60\'/0\'/0/0';
    final String seed = bip39.mnemonicToSeedHex(mnemonic);
    final Chain chain = Chain.seed(seed);
    final ExtendedKey extendedKey = chain.forPath(path);

    final privateKey = extendedKey.privateKeyHex();

    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.address;

    return address;
  }

  @override
  Future<void> importWalletFromSeed(String mnemonic) async {
    const String path = 'm/44\'/60\'/0\'/0/0';
    final String seed = bip39.mnemonicToSeedHex(mnemonic);
    final Chain chain = Chain.seed(seed);
    final ExtendedKey extendedKey = chain.forPath(path);

    final privateKey = extendedKey.privateKeyHex();
    walletRepository.setPrivateKey(privateKey);
  }

  @override
  Future<void> importWalletFromPrivateKey(String privateKey) async {
    walletRepository.setPrivateKey(privateKey);
  }
}
