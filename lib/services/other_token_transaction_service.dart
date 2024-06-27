import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/exceptions/exceptions.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3_wallet/services/pending_transaction_service_impl.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

class OtherTokenService implements TransactionService {
  final PendingTransactionServiceImpl _pendingTransactionService = GetIt.I<PendingTransactionServiceImpl>();

  String? _contractAddress;
  final String _apiUrl = dotenv.env['ALCHEMY_API_KEY']!;
  Web3Client? _client;

  OtherTokenService(String? contractAddress) {
    _contractAddress = contractAddress;
    init();
  }

  @override
  Future<void> init() async {
    if (_client != null) return;
    _client = Web3Client(_apiUrl, Client());
  }

  @override
  Future<EtherAmount> getBalance(String address) async {
    final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');
    final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress!));
    final params = [EthereumAddress.fromHex(address)];
    final balanceFunction = contract.function('balanceOf');

    if (_client == null) throw ('Web3Client is not initialized');
    final balance = await _client!.call(contract: contract, function: balanceFunction, params: params);

    String balanceStr = balance.first.toString();

    BigInt balanceBigInt = BigInt.parse(balanceStr);

    return EtherAmount.inWei(balanceBigInt);
  }

  @override
  Future<String?> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  }) async {
    try {
      if (_client == null) throw ('Web3Client is not initialized');

      final amountInWei = BigInt.from(double.parse(amountToSend) * pow(10, 18));

      final gasPrice = await _client!.getGasPrice();

      // TODO: Repace with loading abi from local storage
      final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');

      final credentials = EthPrivateKey.fromHex(privateKey);

      final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress!));

      final tokenDetails = getTokenDetails();
      final tokenSymbol = tokenDetails.then((value) => value['symbol']);

      final transferFunction = contract.function('transfer');
      final data = transferFunction.encodeCall([EthereumAddress.fromHex(recipientAddress), amountInWei]);

      final transaction = Transaction.callContract(
          contract: contract,
          function: transferFunction,
          parameters: [EthereumAddress.fromHex(recipientAddress), amountInWei],
          gasPrice: gasPrice,
          maxGas: 50000000,
          nonce: await _client!.getTransactionCount(credentials.address));

      final signedTx = await _client!.signTransaction(credentials, transaction, chainId: 11155111);

      final signedTxHex = hexEncode(signedTx);
      String url = "${ApiConstants.apiBaseUrl}/api/web3-helper/send-raw-transaction";
      final response = await http.post(Uri.parse(url), body: {
        "transactionHash": signedTxHex,
        "value": amountToSend,
        "recipientAddress": recipientAddress,
        "symbol": tokenSymbol,
      });
      String? txhash = jsonDecode(response.body)["transactionHash"];

      if (txhash == null) throw ApiException(message: "Transaction failed");

      await _pendingTransactionService.createAndAddSocket(txhash);
      return txhash;
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }

  Future<Map<String, dynamic>> getTokenDetails() async {
    try {
      if (_client == null) throw ('Web3Client is not initialized');

      final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');
      final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress!));

      final nameFunction = contract.function('name');
      final symbolFunction = contract.function('symbol');

      final name = await _client!.call(contract: contract, function: nameFunction, params: []);

      final symbol = await _client!.call(contract: contract, function: symbolFunction, params: []);

      return {
        'name': name,
        'symbol': symbol,
      };
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }

  @override
  bool isInitialized() {
    return _client != null;
  }

  @override
  void setContractAddress(String address) {
    _contractAddress = address;
  }

  String hexEncode(Uint8List input) {
    return hex.encode(input).padLeft((input.length + 1) * 2, "0");
  }
}
