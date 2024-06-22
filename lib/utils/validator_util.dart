import 'dart:convert';

import 'package:web3dart/crypto.dart';

class ValidatorUtil {
  static bool isEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isPassword(String password) {
    return password.length >= 6;
  }

  static bool isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isName(String name) {
    return name.length >= 3;
  }

  static bool isPhoneNumber(String phoneNumber) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber);
  }

  static bool isAddress(String address) {
    return address.length >= 3;
  }

  static bool isValidTokenAddress(String address) {
    address = address.replaceFirst('0x', '');
    var addressHash = keccak256(utf8.encode(address.toLowerCase()));

    for (var i = 0; i < 40; i++) {
      String hashChar = addressHash[i >> 1].toRadixString(16).padLeft(2, '0')[i & 1];
      int hashValue = int.parse(hashChar, radix: 16);
      if ((hashValue > 7 && address[i].toUpperCase() != address[i]) || (hashValue <= 7 && address[i].toLowerCase() != address[i])) {
        return false;
      }
    }

    return true;
  }
}
