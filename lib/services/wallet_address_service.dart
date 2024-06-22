import 'package:dart_bip32_bip44_noflutter/dart_bip32_bip44_noflutter.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:get_it/get_it.dart';
import 'package:hex/hex.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKeyFromMnemonic(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
  Future<void> importWalletFromSeed(String mnemonic);
  Future<void> importWalletFromPrivateKey(String privateKey);
}

class ETHWalletService implements WalletAddressService {
  final walletRepository = GetIt.I<WalletService>();

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKeyFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);

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
