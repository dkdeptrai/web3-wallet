part of 'wallet_cubit.dart';

sealed class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

final class WalletInitial extends WalletState {}

final class WalletLoading extends WalletState {}

final class WalletLoaded extends WalletState {
  final String walletAddress;
  final String privateKey;
  final double balance;

  const WalletLoaded({
    required this.balance,
    required this.walletAddress,
    required this.privateKey,
  });

  @override
  List<Object> get props => [balance, walletAddress, privateKey];
}

final class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}
