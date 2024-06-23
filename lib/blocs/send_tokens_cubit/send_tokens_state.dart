part of 'send_tokens_cubit.dart';

sealed class SendTokensState extends Equatable {
  const SendTokensState();

  @override
  List<Object> get props => [];
}

final class SendTokensInitial extends SendTokensState {}

final class SendingTokens extends SendTokensState {}

final class TokensSent extends SendTokensState {
  const TokensSent();

  @override
  List<Object> get props => [];
}

final class SendTokensError extends SendTokensState {
  final String errorMessage;

  const SendTokensError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
