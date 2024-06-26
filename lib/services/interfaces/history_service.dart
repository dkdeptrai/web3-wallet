import 'package:web3_wallet/model/models.dart';

abstract class HistoryService {
  Future<List<TransactionModel>> fetchHistory({
    required String walletAddress,
    List<String> contractAddresses = const [],
    int page = 0,
    int size = 10,
  });
}
