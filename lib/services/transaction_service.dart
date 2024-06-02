import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class TransactionService {
  final String _apiUrl;
  late Web3Client _client;

  TransactionService(this._apiUrl);
  Future<void> init() async {
    _client = Web3Client(_apiUrl, Client());
  }

  Future<String> sendTransaction(
      String privateKey, String recipientAddress, BigInt amountToSend) async {
    EthPrivateKey ethKey = EthPrivateKey.fromHex(privateKey);
    Credentials credentials = Credentials.fromPrivateKey(ethKey);

    EthereumAddress recipient = EthereumAddress.fromHex(recipientAddress);
    EtherAmount value = EtherAmount.fromBigInt(EtherUnit.wei, amountToSend);

    Transaction transaction = Transaction(
        to: EthereumAddress.fromHex(recipientAddress),
        value: value,
        maxGas: 100000,
        gasPrice: EtherAmount.inWei(BigInt.one),
        nonce: await _client.getTransactionCount(credentials.address));
    transaction.signature = await credentials.signTransaction(transaction);

    return await _client
        .sendTransaction(credentials, transaction)
        .then((txHash) => txHash.toString());
  }
}
