import 'package:dart_bip32_bip44_noflutter/dart_bip32_bip44_noflutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hd_wallet_kit/hd_wallet_kit.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';

import 'package:flutter/foundation.dart';

abstract class WalletAddressService {
  String generateMnemonic();
  Future<String> getPrivateKey(String mnemonic);
  Future<EthereumAddress> getPublicKey(String privateKey);
  Future<EthereumAddress> importWalletFromSeed(String mnemonic);
  Future<EthereumAddress> importWalletFromPrivateKey(String privateKey);
}

class WalletProvider extends ChangeNotifier implements WalletAddressService {
  final _storage = FlutterSecureStorage();
  String? privateKey;

  Future<void> loadPrivateKey() async {
    privateKey = await _storage.read(key: 'privateKey');
  }

  Future<void> setPrivateKey(String privateKey) async {
    await _storage.write(key: 'privateKey', value: privateKey);
    this.privateKey = privateKey;
    notifyListeners();
  }

  @override
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(master.key);

    await setPrivateKey(privateKey);
    return privateKey;
  }

  @override
  Future<EthereumAddress> getPublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.address;
    return address;
  }

  @override
  Future<EthereumAddress> importWalletFromSeed(String mnemonic) async {
    // final privateKey = await getPrivateKey(mnemonic);

    // final publicKey = await getPublicKey(privateKey);
    // return publicKey;

    const String path = 'm/44\'/60\'/0\'/0/0';
    final String seed = bip39.mnemonicToSeedHex(mnemonic);
    final Chain chain = Chain.seed(seed);
    final ExtendedKey extendedKey = chain.forPath(path);
    final privateKey = extendedKey.privateKeyHex();
    final publicKey = await getPublicKey(privateKey);
    setPrivateKey(privateKey);
    print(
        "privateKey: $privateKey, publicKey: $publicKey, publicKeyFromExtendedKey: ${extendedKey.publicKey()}");
    return publicKey;
  }

  @override
  Future<EthereumAddress> importWalletFromPrivateKey(String privateKey) async {
    await setPrivateKey(privateKey);
    final publicKey = await getPublicKey(privateKey);
    return publicKey;
  }

  Future<void> deletePrivateKey() async {
    await _storage.delete(key: 'privateKey');
    privateKey = null;
    notifyListeners();
  }
}
