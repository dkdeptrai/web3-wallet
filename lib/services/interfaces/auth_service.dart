import 'package:web3_wallet/model/models.dart';

abstract class AuthService {
  Future<UserModel> authenticate({required String publicAddress});
  Future<UserModel> register({required String publicAddress});
}
