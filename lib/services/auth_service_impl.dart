import 'dart:convert';

import 'package:web3_wallet/constants/constants.dart';
import 'package:web3_wallet/exceptions/api_exception.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';
import 'package:http/http.dart' as http;

class AuthServiceImpl implements AuthService {
  @override
  Future<UserModel> authenticate({required String publicAddress}) async {
    const String url = ApiConstants.login;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "publicAddress": publicAddress,
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw ApiException(message: "Failed to authenticate");
    }
  }

  @override
  Future<UserModel> register({required String publicAddress}) async {
    const String url = ApiConstants.register;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "publicAddress": publicAddress,
      }),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.body);
    } else {
      throw ApiException(message: "Failed to authenticate");
    }
  }
}
