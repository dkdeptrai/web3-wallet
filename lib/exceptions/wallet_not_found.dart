class WalletNotFoundException implements Exception {
  final String message;

  WalletNotFoundException(this.message);
}
