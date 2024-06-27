import 'package:web3dart/web3dart.dart';

abstract class TransactionService {
  void init();
  void setContractAddress(String address);
  Future<EtherAmount> getBalance(String address);
  Future<void> sendTransaction({
    required String privateKey,
    required String recipientAddress,
    required String amountToSend,
  });
  bool isInitialized();
}
