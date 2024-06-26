class Token {
  final String name;
  final String symbol;
  final String balance;
  final String? contractAddress;
  Token({
    required this.name,
    required this.symbol,
    required this.balance,
    this.contractAddress,
  });
}
