import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class PasswordUtil {
  static Future<void> savePassword(String password) async {
    final secureStorage = GetIt.I.get<FlutterSecureStorage>();
    secureStorage.write(key: 'password', value: password);
  }

  static Future<void> deletePassword() async {
    final secureStorage = GetIt.I.get<FlutterSecureStorage>();
    secureStorage.delete(key: 'password');
  }

  static Future<bool> verifyPassword(String password) async {
    final secureStorage = GetIt.I.get<FlutterSecureStorage>();

    final storedPassword = await secureStorage.read(key: 'password');
    print("storedPassword: $storedPassword");
    print(password);
    return storedPassword == password;
  }

  static Future<bool> hasPassword() async {
    final secureStorage = GetIt.I.get<FlutterSecureStorage>();
    final storedPassword = await secureStorage.read(key: 'password');
    return storedPassword != null;
  }
}
