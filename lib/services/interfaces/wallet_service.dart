abstract class WalletService {
  Future<String?> getPrivateKey();
  Future<void> setPrivateKey(String privateKey);
  Future<void> deletePrivateKey();
  Future<void> saveTokenAddress(String address);
  Future<List<String>?> getStoredTokenAddresses();
}
