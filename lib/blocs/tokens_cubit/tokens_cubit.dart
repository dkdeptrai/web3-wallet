import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:web3_wallet/model/models.dart';
import 'package:web3_wallet/services/interfaces/interfaces.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  final TokenService tokenService = GetIt.I<TokenService>();

  TokensCubit() : super(TokensInitial());

  Future<void> loadTokens(String walletAddress) async {
    emit(TokensLoading());
    try {
      print("Load tokens for wallet: $walletAddress");
      List<Token> tokens = await tokenService.loadStoredTokens(walletAddress: walletAddress);
      print("My tokens: $tokens");
      emit(TokensLoaded(tokens));
    } catch (e) {
      emit(TokensError(e.toString()));
    }
  }

  Future<void> importToken(String address) async {
    await tokenService.importToken(address: address);
  }
}
