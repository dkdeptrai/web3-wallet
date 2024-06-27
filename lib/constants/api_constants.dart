class ApiConstants {
  // static const String webSocketUrl = "wss://192.168.0.4:3000";
  // static const String apiBaseUrl = "https://192.168.0.4:3000";
  static const String webSocketUrl = "wss://192.168.50.177:3000";
  static const String apiBaseUrl = "https://192.168.50.177:3000";

  // News apis
  static const String newsApi = "$apiBaseUrl/api/news";

  // History apis
  static const String fetchHistories =
      "$apiBaseUrl/api/web3-helper/get-transaction-history";
}
