import 'package:web3_wallet/model/models.dart';

abstract class TokenService {
  Future<List<Token>> loadStoredTokens({required String walletAddress});
  Future<void> importToken({required String address});
}
