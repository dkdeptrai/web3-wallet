import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3_wallet/exceptions/wallet_not_found.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:web3dart/web3dart.dart';

class OtherTokenService extends TransactionService {
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
    if (_contractAddress == null) throw WalletNotFoundException("Contract address is not set");

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
  Future<TransactionReceipt> sendTransaction({required String privateKey, required String recipientAddress, required double amountToSend}) async {
    if (_contractAddress == null) throw WalletNotFoundException("Contract address is not set");

    try {
      final amountInWei = BigInt.from(amountToSend * pow(10, 18));

      final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');
      final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress!));

      final transferFunction = contract.function('transfer');
      final data = transferFunction.encodeCall([EthereumAddress.fromHex(recipientAddress), amountInWei]);

      final credentials = EthPrivateKey.fromHex(privateKey);
      final transaction = Transaction(from: await credentials.address, to: contract.address, value: EtherAmount.zero(), data: data);

      if (_client == null) throw ('Web3Client is not initialized');

      final signedTx = await _client!.signTransaction(credentials, transaction);
      final txHash = await _client!.sendRawTransaction(signedTx);

      TransactionReceipt? receipt;
      while (receipt == null) {
        await Future.delayed(const Duration(seconds: 5));
        receipt = await _client!.getTransactionReceipt(txHash);
      }

      return receipt;
    } catch (e) {
      print('Transaction failed: $e');
      throw ('Transaction failed: $e');
    }
  }

  Future<Map<String, dynamic>> getTokenDetails() async {
    if (_contractAddress == null) throw WalletNotFoundException("Contract address is not set");

    try {
      final abiCode = await rootBundle.loadString('assets/abi/erc20tokenabi.json');
      final contract = DeployedContract(ContractAbi.fromJson(abiCode, 'ERC20Token'), EthereumAddress.fromHex(_contractAddress!));

      final nameFunction = contract.function('name');
      final symbolFunction = contract.function('symbol');

      if (_client == null) throw ('Web3Client is not initialized');

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
}
