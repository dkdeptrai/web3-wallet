import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class WalletRepository {
  Future<String?> getPrivateKey();
  Future<void> setPrivateKey(String privateKey);
  Future<void> deletePrivateKey();
}

class SecureStorageWalletRepository implements WalletRepository {
  final _storage = FlutterSecureStorage();

  static const _tokenAddressesKey = 'tokenAddresses';
  @override
  Future<String?> getPrivateKey() async {
    return await _storage.read(key: 'privateKey');
  }

  @override
  Future<void> setPrivateKey(String privateKey) async {
    await _storage.write(key: 'privateKey', value: privateKey);
  }

  @override
  Future<void> deletePrivateKey() async {
    await _storage.delete(key: 'privateKey');
  }

  Future<void> saveTokenAddress(String address) async {
    List<String>? storedAddress = await getStoredTokenAddresses();
    storedAddress?.add(address);
    await _storage.write(
        key: _tokenAddressesKey, value: jsonEncode(storedAddress));
  }

  Future<List<String>?> getStoredTokenAddresses() async {
    String? storedAddressesJson = await _storage.read(key: _tokenAddressesKey);
    if (storedAddressesJson != null) {
      return jsonDecode(storedAddressesJson).cast<String>();
    }
    return [];
  }
}
