import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class WalletRepository {
  Future<String?> getPrivateKey();
  Future<void> setPrivateKey(String privateKey);
  Future<void> deletePrivateKey();
}

class SecureStorageWalletRepository implements WalletRepository {
  final _storage = FlutterSecureStorage();

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
}
