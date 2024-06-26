import 'dart:convert';

import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/exceptions/exceptions.dart';
import 'package:web3_wallet/model/history_model.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:http/http.dart' as http;

class HistoryServiceImpl implements HistoryService {
  @override
  Future<List<History>> fetchHistory({
    required String walletAddress,
    List<String> contractAddresses = const [],
    int page = 0,
    int size = 10,
  }) async {
    try {
      print("Start [HistoryServiceImpl.fetchHistory]");

      const String url = ApiConstants.fetchHistories;

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "walletAddress": walletAddress,
          "contractAddresses": contractAddresses,
          "page": page,
          "pageSize": size,
        }),
      );
      print("Response [HistoryServiceImpl.fetchHistory]: ${response.body}");

      if (response.statusCode == 200) {
        final List<History> articles =
            jsonDecode(response.body)['transactions'].map<History>((item) => History.fromMap(item as Map<String, dynamic>)).toList();
        return articles;
      } else {
        throw ApiException(message: "[HistoryServiceImpl.fetchHistory] HTTP error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error [HistoryServiceImpl.fetchHistory]: $e");
      throw Exception(e);
    }
  }
}
