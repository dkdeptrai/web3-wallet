import 'package:get_it/get_it.dart';
import 'package:web3_wallet/model/token_model.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/services.dart';
import 'package:web3dart/web3dart.dart';

class TokenServiceImpl implements TokenService {
  final _walletService = GetIt.I<WalletService>();
  final OtherTokenService _otherTokenService = GetIt.I<OtherTokenService>();

  @override
  Future<List<Token>> loadStoredTokens({required String walletAddress}) async {
    List<Token> tokens = [];
    List<String>? tokenAddresses =
        await _walletService.getStoredTokenAddresses();
    if (tokenAddresses != null && tokenAddresses.isNotEmpty) {
      for (String address in tokenAddresses) {
        _otherTokenService.setContractAddress(address);

        Map<String, dynamic> tokenDetails =
            await _otherTokenService.getTokenDetails();

        EtherAmount balance =
            await _otherTokenService.getBalance(walletAddress);
        String balanceStr = balance.getValueInUnit(EtherUnit.ether).toString();

        print(
            "Checking token: ${tokenDetails['name']} (${tokenDetails['symbol']})");

        bool tokenExists = tokens.any((token) =>
            token.name == tokenDetails['name'] &&
            token.symbol == tokenDetails['symbol']);

        if (!tokenExists) {
          Token token = Token(
              name: tokenDetails['name'].toString(),
              symbol: tokenDetails['symbol'].toString(),
              balance: balanceStr);
          tokens.add(token);
        } else {
          print(
              "Duplicate token found: ${tokenDetails['name']} (${tokenDetails['symbol']})");
        }
      }
    }
    return tokens;
  }

  @override
  Future<void> importToken({required String address}) async {
    try {
      await _walletService.saveTokenAddress(address);
      //! Instructions for importing token
      // TODO: Save the address, then fetch the abi.json file content from Backend Server, then save it to local storage
      // TODO: When loading token, load initialize the OtherTokenService with the abi.json file content from local storage
    } catch (e) {
      print("[TokenServiceImpl] Error importing token: $e");
      rethrow;
    }
  }
}
