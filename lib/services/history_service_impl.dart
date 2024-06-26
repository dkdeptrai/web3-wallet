import 'dart:convert';

import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/exceptions/exceptions.dart';
import 'package:web3_wallet/model/transaction_model.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:http/http.dart' as http;

class HistoryServiceImpl implements HistoryService {
  @override
  Future<List<TransactionModel>> fetchHistory({
    required String walletAddress,
    List<String> contractAddresses = const [],
    int page = 1,
    int size = 10,
  }) async {
    try {
      print("Start [HistoryServiceImpl.fetchHistory]");

      const String url = ApiConstants.fetchHistories;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "address": walletAddress,
          "contractAddresses": contractAddresses,
          "page": page,
          "pageSize": size,
        }),
      );
      print("Response [HistoryServiceImpl.fetchHistory]: ${response.body}");

      if (response.statusCode == 200) {
        final List<TransactionModel> transactions = jsonDecode(response.body)['transactions']
            .map<TransactionModel>((item) => TransactionModel.fromMap(item as Map<String, dynamic>))
            .toList();
        return transactions;
      } else {
        throw ApiException(message: "[HistoryServiceImpl.fetchHistory] HTTP error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error [HistoryServiceImpl.fetchHistory]: $e");
      throw Exception(e);
    }
  }
}
