import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getBalances(String address, String chain) async {
  // final url = Uri.http(dotenv.env['BACKEND_ADDRESS']!, '/jsonrpc', {
  //   'address': address,
  //   'chain': chain,
  // });
  Map<String, dynamic> requestBody = {
    "id": 1,
    "jsonrpc": "2.0",
    "params": [address, "latest"],
    "method": "eth_getBalance"
  };
  String jsonString = jsonEncode(requestBody);
  var headers = {
    'Content-Type': 'application/json',
  };

  final response = await http.post(
    Uri.http(dotenv.env['BACKEND_ADDRESS']!, '/jsonrpc'),
    headers: headers,
    body: jsonString,
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    String hexResult = jsonResponse['result'];
    int decimalValue = int.parse(hexResult.substring(2), radix: 16);
    return decimalValue.toString();
  } else {
    throw Exception('Failed to get balances');
  }
}
